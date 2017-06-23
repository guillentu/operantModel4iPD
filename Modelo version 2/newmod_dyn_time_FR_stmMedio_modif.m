%% Experimento con Fixed-Ratio - FR - Tasa fija
%% Existen multiples intancias de palanquelo (cada vez que realiza respuesta decide si realiza otro o no)
%% Sesiones de 3600 segundos
%% 3 sesiones por tasa de refuerzo (o quizas hasta que sature)
%% 5 sesiones por Experimento.
%% Cada sesion 
%% Tiempo para realizar un respuesta 1 segundo
%% 
%% La probabilidad de eleccion se ajusta al nivel de maxima frecuencia de palanqueo

close all
clc
clear

%% Matriz de pago 0 1 
%% 1 - 
%%%
%%% 
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
Fr=[1,10,30,40,60];
Ntest   =  1;
limrand =  0.138;
saving  =  0.01 ;
%%%%%% CONSTANTES DE DECAIMIENTO
alpha = 1*tMuestreo;
beta  = 0.125*tMuestreo ;
gamma = 0.0067*tMuestreo;%0.025 ; 
delta = 1*tMuestreo;
%%%%%% INICIALIZACION
palanca = zeros(2,1);
Rf_1=0;
Rf_2=0;
A1=zeros(1,Ntest);
A2=zeros(1,Ntest);
stm_1=zeros(2,Ntest);
stm_2=zeros(2,Ntest);
d=1;
x_1=zeros(30,1);
x_2=zeros(30,1);
sesion = zeros(Nses,1);
trialXsesion = zeros(Nses,Ntrial);
terminal_sesion=zeros(Nses,1);
nb_resp = zeros(Nses,Ntest);
contadorP1=0;
contadorP2=0;

%% CALCULO DE AROUSAL MAXIMO
%% Iteraciones de respuesta refuerzo para encotnrar el STM medio
Nconfig=10; %% Tasa de respuesta de configuracion
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
    i=2;
    %duracion = [1,tTrial*ones(1,Ntrial)];
    
    contador = 1;
    palanca(1)=randi(2);
    %% Agregar tasa de refuerzos  %%
    
    if k>1
      A1(Num+1,l)=saving*A1(Num,l);
      A2(Num+1,l)=saving*A2(Num,l);
      stm_1(Num+1,l)=0*stm_1(Num,l);
      stm_2(Num+1,l)=0*stm_2(Num,l); 
      %%% ELECCION DE LA PRIMERA PALANCA 
      if A1(Num,1)>A2(Num,1)
        palanca(2)=1;
      else
        palanca(2)=2;
      end
    end       
    
    for j=2:(Ntrial*tTrial/tMuestreo) %% Todos los trials juntos
      
      if contador == tResp/tMuestreo%duracion(i)
        contador = 1;
        
        i = i+1 ;
        J = j ;
        P(i,k)=0.5*(1-exp(-(5*A1((j-1)+Num,l))/A1max))+0.5; %probabilidad en exponential
        %P=.99;
        %P2(i,k)=0.5*(1-exp(-(5*A2((j-1)+Num,l))/A2max))+0.5;
        
        a = rand ;
        %%% ELECCION DE LA PALANCA %%% Basicamente elige palanquear o no palanquear
        if (A1((j-1)+Num,l)<=limrand)&&(A2((j-1)+Num,l)<=limrand)
          palanca(i)=randi(2);
        elseif (A1((j-1)+Num,l)>=limrand)&&(A2((j-1)+Num,l)<=limrand)
          if a>=P(i,k)
            palanca(i)=2;
          else
            palanca(i)=1;
          end
        elseif (A1((j-1)+Num,l)<=limrand)&&(A2((j-1)+Num,l)>=limrand)
          if a>=P(i,k)
            palanca(i)=1;
          else
            palanca(i)=2;
          end
        end
        %% Contadores para tasa de refuerzo
        if palanca(i)==1
          contadorP1++;
        else
          contadorP2++;
        endif
        %%% REFUERZO %%%
        if (contadorP1==Fr(k))
          %if (palanca(i)==1) %% palanquea
          Rf_1=floor(feel(1));
          Rf_2=0;
          %elseif (palanca(i-1)==2) %% No palanquea
          %  Rf_1=0;
          %  Rf_2=0;%floor(10*(1-exp(-0.8* 2 )));
          %end
          %stm_1(j+Num,l)=(1-beta)*stm_1((j-1)+Num,l)+alpha*Rf_1;
          %stm_2(j+Num,l)=(1-beta)*stm_2((j-1)+Num,l)+alpha*Rf_2;
          contadorP1=0;
        end
      else
        contador++;%=contador +1;
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

%%% PRUEBA III _ EN QUE SESION LA PALANCA GANA DE VERDAD
%ird = zeros(Ntest,1);
%for k = 1:Ntest
%  i=1;
%  while 1
%    if A1(nonnul(k)-i,k) < limrand
%      ird(k) = nonnul(k)-i+1;
%      break;
%    else
%      i=i+1;
%    end
%  end
%end
%
%%%% PRUEBA IV _ CONVIERTE J EN NUMERO DE SESION
%for k = 1:Ntest
%  i=1;
%  while 1
%    if ird(k) <= sum(sesion(1:i)+50)
%      ird(k)=i;
%      break;
%    else
%      i=i+1;
%    end
%  end
%end

%%% PRUEBA V _ PORCENTAJE DE COOPERACION POR SESION / EXPERIMENTO


%porcentaje_coop_sesion=zeros(Nses,Ntest);
%porcentaje_coop_experimento=zeros(Ntest,1);
%for k = 1:Ntest
%  porcentaje_coop_experimento(k)=sum(nb_coop(:,k))/(Ntrial*Nses)*100;
%end

%for i=1:Ntest
%  terminal_sesion(1,i)=sesion(1,i);
%  for j=2:Nses
%    terminal_sesion(j,i)=sesion(j,i)+terminal_sesion(j-1,i);
%  end
%end

%%% DEMOSTRACION 


%promedio_sesion=sum(ird)/Ntest
%porcent_10xsuperior_al_otra=porcent/Ntest * 100;
%cuanto_alcanzan_al_maxima=sum(maxima)/Ntest * 100;
%porcentaje_coop_experimento;
resp_por_segundos=nb_resp/length(palanca); %numero de respuestas dividido por el numero de respestas maximal posible
for k=1:Nses
  rf_por_segundos=floor(nb_resp(k)/



for i=1:Ntest
  figure
  hold on
  plot((1:Sizemat)*tMuestreo,A1(:,i),'r',(1:Sizemat)*tMuestreo,A2(:,i),'b',(1:Sizemat)*tMuestreo,stm_1(:,i),'g',(1:Sizemat)*tMuestreo,stm_2(:,i),'m',(1:Sizemat)*tMuestreo,limrand*ones(1,Sizemat),'--b')
  legend("A1","A2","STM1","STM2","limrand");
  for j=1:Nses
    %plot(sesion(j,i)*ones(1,max(max(A1(:,i)))),(1:max(max(A1(:,i)))),'--k');
    h=plot((sesion(j,i).*tMuestreo)*ones(1,max(max(A1(:,i)))),(1:max(max(A1(:,i)))),'--k');
    set(h, "linewidth", 2);
    if j==1
      h=plot(0:sesion(j,i)/4,P(:,j)'*A1max,'.-m');
    else
      h=plot(sesion(j-1,i)/4:sesion(j,i)/4,P(:,j)'*A1max,'.-m');
    endif
  endfor
  plot((0:sesion(Nses,i))/4,A1max*ones(1,length(0:sesion(Nses,i))))
  hold off;
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
end
hold off

figure
hold on
for i=1:Ntest
  plot(Fr,resp_por_segundos(:,i),'Color',color(i));
  title('Respuestas por segundos');
  xlabel('Tasa fija');
  ylabel('Respuestas/segundos');
end
hold off

%%% haut CQFD
%%%% CASTIGO DE TIEMPO 
%%%% CUANTO VECES ELIGE COOPERATION
%%% Pour chaque session r�cup�rer le nombre de coop�ration et tracer la
%%% courbe correspondante 

