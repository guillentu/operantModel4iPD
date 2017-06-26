%% Experimento con Fixed-Ratio - FR - Tasa fija
%% Existen multiples intancias de palanquelo (cada vez que realiza respuesta decide si realiza otra o no)
%% Durante la tasa se contabilizan los palanqueos y no palanqueos y el refuerzo impacta de forma 
%% proporcional a la tasa de respuestas.
%% Un trial dura 3600 segundos.
%% Una sesion 1 o 3 trial (seg´un la dinamica del animal)
%% 5 sesiones por Experimento. Cada sesion es un intervalo diferente.
%% 1 experimento
%% Tiempo para realizar un respuesta 1 segundo
%% 
%% La probabilidad de eleccion se ajusta al nivel de maxima frecuencia de palanqueo
%% 

close all
clc
clear

%% Matriz de pago 0 1 

%%% Se ajusto la apreciacion de las cantidades de refuerzo 
function rf = feel(pellets)
  rf=0;
  if (nargin~=0)
    rf=(12.8*(1-exp(-.25.* pellets.^(2))))+(12.8*(1-exp(-.5.* pellets)));
  else
    error ("Faltan parametros");
  endif
endfunction
%% 
%% 

%% INICIALIZATION
%%%%%% CONSTANTES DE SESIONES
Ntrial  =  1 ;   %% un trial de 3600 segundos
tTrial  =  3600; %% en segundos
tResp   =  1;    %% en segundos
tMuestreo = 0.25;%% en segundos
Nses    =  5 ;
Fr=[1,10,30,40,60]; %% valores medios de intervalos variables
Ntest   =  1;
limrand =  0.138;
saving  =  0.9 ;
%%%%%% CONSTANTES DE DECAIMIENTO
alpha = 10/tMuestreo; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
beta  = 0.13*0.31*tMuestreo;%0.125*tMuestreo ;
gamma = 0.0067*tMuestreo;%0.025 ; 
delta = 1/tMuestreo; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55555
%%%%%% INICIALIZACION
palanca = zeros(2,1);
Rf_1=0;
Rf_2=0;
A1=zeros(1,Ntest);
A2=zeros(1,Ntest);
stm_1=zeros(2,Ntest);
stm_2=zeros(2,Ntest);
d=1;

sesion = zeros(Nses,1);
trialXsesion = zeros(Nses,Ntrial);
terminal_sesion=zeros(Nses,1);
nb_resp = zeros(Nses,Ntest);
contadorP1=0;
contadorP2=0;
contadorI=0;

%% CALCULO DE AROUSAL MAXIMO
%% Iteraciones de respuesta refuerzo para encotnrar el STM medio
Nconfig=5; %% Tasa de respuesta de configuracion
%plot([1:0.01:20],(12.8*(1-exp(-.25.* [1:0.01:20].^(2))))+(12.8*(1-exp(-.5.* [1:0.01:20]))),'.k')
R1 = floor(feel(1)); %tiempo de refuezo para R
l1 = Nconfig/tMuestreo; % duracion entre trials
suma = 0; %suma es un valor necesaria para calcular max1 y min1
suma = alpha*R1 %% Refuerzo cada N respuestas
iter=100; %% numero de iteraciones para que converja el stm
max1 = 0; %maximum de stm1
min1 = 0; %minimum de stm1
for i = 1:iter 
  suma = (1-beta)^(Nconfig/tMuestreo)*suma;%% Instantes que decae el stm
  min1=suma;
  suma += alpha*R1; %Refuerzo
  max1=suma;
end
comp=.88;
S1 = (((max1-min1)*(comp*l1))/2)+min1*comp*l1; %calcul de la superficie del triangulo mas la de el rectangulo
stm_1_medio = S1/(l1);
A1max = (delta/gamma)*stm_1_medio;

%% INICIO DE LAS ITERATIONS
for l = 1:Ntest  %% TESTES
  Num=0;
  for k = 1:Nses  %% SESIONES (cambia el N)
    i=1;
    %duracion = [1,tTrial*ones(1,Ntrial)];
    
    contador = 1;
    %palanca(1)=randi(2);
    
    %% Agregar tasa de refuerzos  %%
    tasa=Fr(k);
    if k>1
      A1(Num+1,l)=saving*A1(Num,l);
      A2(Num+1,l)=saving*A2(Num,l);
      stm_1(Num+1,l)=0*stm_1(Num,l);
      stm_2(Num+1,l)=0*stm_2(Num,l); 
      %%% ELECCION DE LA PRIMERA PALANCA 
%      if A1(Num,1)>A2(Num,1)
%        palanca(2)=1;
%      else
%        palanca(2)=2;
%      end
    end       
    P1(i,k)=0.5;
    P1(i,k)=0.5;
    for j=2:(Ntrial*tTrial/tMuestreo) %% Todos los trials juntos
      
      if contador == tResp/tMuestreo%duracion(i)
        contador = 1;
        i = i+1 ;
        J = j ;
        P1(i,k)=0.5*(1-exp(-(5*A1((j-1)+Num,l))/A1max))+0.5; %probabilidad en exponential
        P2(i,k)=0.5*(1-exp(-(5*A2((j-1)+Num,l))/A1max))+0.5; %probabilidad en exponential
        %P=.99;
        %P2(i,k)=0.5*(1-exp(-(5*A2((j-1)+Num,l))/A2max))+0.5;
        
        a = rand ;
        %%% ELECCION DE LA PALANCA %%% Basicamente elige palanquear o no palanquear
        if (A1((j-1)+Num,l)<=limrand)&&(A2((j-1)+Num,l)<=limrand)
          palanca(i)=randi(2);
        elseif (A1((j-1)+Num,l)>=limrand)&&(A2((j-1)+Num,l)<=limrand)
          if a>=P1(i,k)
            palanca(i)=2;
          else
            palanca(i)=1;
          end
        elseif (A1((j-1)+Num,l)<=limrand)&&(A2((j-1)+Num,l)>=limrand)
          if a>=P2(i,k)
            palanca(i)=1;
          else
            palanca(i)=2;
          end
        elseif (A1((j-1)+Num,l)>A2((j-1)+Num,l))
          if a>=P1(i,k)
            palanca(i)=2;
          else
            palanca(i)=1;
          end
        else
          if a>=P2(i,k)
            palanca(i)=1;
          else
            palanca(i)=2;
          end
        end
        %% Contadores para intervalo de refuerzo
        if palanca(i)==1
          contadorP1++;
        else
          contadorP2++;
        endif
        %%% REFUERZO %%%
        if (contadorP1>=tasa)
          %if (palanca(i)==1) %% palanquea
          aux=contadorP1+contadorP2;
          Rfz=floor(feel(1));
          Rf_1=Rfz*contadorP1/aux;
          Rf_2=Rfz*contadorP2/aux;
          %elseif (palanca(i-1)==2) %% No palanquea
          %  Rf_1=0;
          %  Rf_2=0;%floor(10*(1-exp(-0.8* 2 )));
          %end
          %stm_1(j+Num,l)=(1-beta)*stm_1((j-1)+Num,l)+alpha*Rf_1;
          %stm_2(j+Num,l)=(1-beta)*stm_2((j-1)+Num,l)+alpha*Rf_2;
          contadorP1=0;
          contadorP2=0;
          contadorI =0;
          dispe=.5; %% dispercion del 50% del valor de la intervalo
          tasa=Fr(k);
        endif
        
      else
        contador++;
        contadorI++;
        Rf_1=0;
        Rf_2=0;
      end
      stm_1(j+Num,l)=(1-beta)*stm_1((j-1)+Num,l)+alpha*Rf_1;
      stm_2(j+Num,l)=(1-beta)*stm_2((j-1)+Num,l)+alpha*Rf_2;
      A1(j+Num,l)=(1-gamma)*A1((j-1)+Num,l)+delta*stm_1(j+Num,l);
      A2(j+Num,l)=(1-gamma)*A2((j-1)+Num,l)+delta*stm_2(j+Num,l);
      
%      if floor(j/tTrial)==(j/tTrial)
%        trialXsesion()
%      end
    end
    
    
    %%% CONTADOR DE A QUE J SE CAMBIA LA SESION
    %sesion(k-1,l)=j;
    sesion(k,l)=j+Num;
    %%% DEFINICION DE NUM
%    compteur = 0 ;
%    for i=1:length(A1(:,l))
%      if A1(i,l)~=0
%        compteur = compteur +1;
%      end
%    end
%    Num=compteur;
    Num = j+Num;
    Sizemat = length(A1);
    
    for j = 1:length(palanca)
      if palanca(j)==1
        %nb_coop(k-1,l)= nb_coop(k-1,l)+1;
        nb_resp(k,l)= nb_resp(k,l)+1;
      end
    end
  end
end


%%% PRUEBAS 
%%% ENCONTRA LA LONGITUD REAL DEL EXPERIMENTACION
nonnul = zeros(Ntest,1);
for k=1:Ntest
  for i=1:length(A1)
    if A1(i,k) ~= 0
      nonnul(k)=nonnul(k)+1;
    end
  end
end

%%% PRUEBA I _ PESO DE LA EXPERIMENTACION EN LA MEMORIA
porcent = 0;
for i = 1:Ntest
  if sum(A1(:,i)) > 10 * sum(A2(:,i))
    porcent = porcent +1;
  end
end

%%% PRUEBA II _ SI LA EXCITATION ALCANZA A SU MAXIMUM
maxima = zeros(Ntest,1);
for k = 1:Ntest
  if floor(max(A1(:,k))) == floor(max(max(A1))) 
    maxima(k) = maxima(k) +1;
  end
end



resp_por_segundos=nb_resp/length(palanca); %numero de respuestas dividido por el numero de respestas maximal posible

for i=1:Ntest
  for k=1:Nses
    refuerzo(k,i)=floor(nb_resp(k,i)/Fr(k));
  end
end


for i=1:Ntest
  for j=1:Nses
    figure
    hold on
    %plot(sesion(j,i)*ones(1,max(max(A1(:,i)))),(1:max(max(A1(:,i)))),'--k');
    %h=plot((sesion(j,i).*tMuestreo)*ones(1,max(max(A1(:,i)))),(1:max(max(A1(:,i)))),'--k');
    %set(h, "linewidth", 2);
    if j==1
      plot(1:Ntrial*tTrial/tMuestreo,A1(1:sesion(j,i),i),'r',1:Ntrial*tTrial/tMuestreo,A2(1:sesion(j,i),i),'b',1:Ntrial*tTrial/tMuestreo,stm_1(1:sesion(j,i),i),'g',1:Ntrial*tTrial/tMuestreo,stm_2(1:sesion(j,i),i),'m',1:Ntrial*tTrial/tMuestreo,limrand*ones(1,Ntrial*tTrial/tMuestreo),'--b');
      plot((1:(Ntrial*tTrial))/tMuestreo,P1(:,j)'*A1max,'.-m');
      legend("A1","A2","STM1","STM2","limrand","probabilidad");
    else
      plot(1:Ntrial*tTrial/tMuestreo,A1(sesion(j-1,i)+1:sesion(j,i),i),'r',1:Ntrial*tTrial/tMuestreo,A2(sesion(j-1,i)+1:sesion(j,i),i),'b',1:Ntrial*tTrial/tMuestreo,stm_1(sesion(j-1,i)+1:sesion(j,i),i),'g',1:Ntrial*tTrial/tMuestreo,stm_2(sesion(j-1,i)+1:sesion(j,i),i),'m',1:Ntrial*tTrial/tMuestreo,limrand*ones(1,Ntrial*tTrial/tMuestreo),'--b');
      plot((1:(Ntrial*tTrial))/tMuestreo,P1(:,j)'*A1max,'.-m');
      legend("A1","A2","STM1","STM2","limrand","probabilidad");
    endif
    plot(1:Ntrial*tTrial/tMuestreo,A1max*ones(1,Ntrial*tTrial/tMuestreo));
    hold off
  endfor
endfor


%% Maximos exitos por tasa= 10-360 - 30-120 - 40-65 - 60-60 

color = 'rgbmkmrgbk';
figure
hold on
for i=1:Ntest
  plot(Fr,resp_por_segundos(:,i),'Color',color(i));
  title('Respuestas por segundos');
  xlabel('Tasa fija');
  ylabel('Respuestas/segundos');
  for j=1:Nses
    plot(Fr(j)*ones(1,floor(resp_por_segundos(j,i)*100)+1),(0:floor(resp_por_segundos(j,i)*100))/100,'k');
  end
end
hold off

figure
hold on
for i=1:Ntest
  plot(refuerzo(:,i),resp_por_segundos(:,i),'Color',color(i));
  title('Respuestas y refuerzo');
  xlabel('Refuezo/horas');
  ylabel('Respuestas/segundos');
  for j=1:Nses
    plot(refuerzo(j)*ones(1,floor(resp_por_segundos(j,i)*100)+1),(0:floor(resp_por_segundos(j,i)*100))/100,'k');
    a = strcat('Num= ',num2str(Fr(j)));
    if j==3
      text(refuerzo(j),-.085,a);
    elseif j==4
      text(refuerzo(j),-.1,a);
    elseif j==5
      text(refuerzo(j),-.03,a);
    else
      text(refuerzo(j),-.06,a);
    end
  end
end
hold off

%%% probl�me de temps, pas le temps de d�croitre du coup red�marre plus
%%% haut CQFD
%%%% CASTIGO DE TIEMPO 
%%%% CUANTO VECES ELIGE COOPERATION
%%% Pour chaque session r�cup�rer le nombre de coop�ration et tracer la
%%% courbe correspondante 
