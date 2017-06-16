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

%% 
%% 

%% INICIALIZATION
%%%%%% CONSTANTES DE DECAIMIENTO
alpha = 1;
beta  = 0.125 ;
gamma = 0.0067;%0.025 ; 
delta = 1;

%%%%%% CONSTANTES DE SESIONES
Ntrial  =  1 ;   %% un trial de 3600 segundos
tTrial  =  3600; %% en segundos
tResp   =  1;    %% en segundos
tMuestreo = 0.25;%% en segundos
Nses    =  2 ;
Fr=[3, 15];
Ntest   =  1;
limrand =  0.138;
saving  =  0.01 ;

%% CALCULO DE AROUSAL MAXIMO
%plot([1:0.01:20],(12.8*(1-exp(-.25.* [1:0.01:20].^(2))))+(12.8*(1-exp(-.5.* [1:0.01:20]))),'.k')
function rf = feel(pellets)
  rf=0;
  if (nargin~=0)
    rf=(12.8*(1-exp(-.25.* pellets.^(2))))+(12.8*(1-exp(-.5.* pellets)));
  else
    error ("Faltan parametros");
  endif
endfunction

tau = 0.5 ;
R1 = floor(feel(1)); %tiempo de refuezo para R
R2 = floor(feel(2)); %tiempo de refuezo para T

l1 = 20+R1; %20 = duraci�n entre trials
%l2 = 48+R2; %48 = 20 entre trials + 8 de castigo + 20 entre trials

%suma = 0; %suma es un valor necesaria para calcular max1 y min1
%for i = 1:5
%  suma = suma+alphaAP*(1-betaAP)^(i-1);
%end
%
%max1 = 0; %maximum de stm1
%min1 = 0; %minimum de stm1
%for i = 1:5
%  max1 = suma + min1*(1-betaAP)^5;
%  min1 = max1*(1-betaAP)^20;
%end
%
%max2 = 0; %maximum de stm2
%for i = 1:8
%  max2 = max2+alphaAP*(1-betaAP)^(i-1);
%end
%
%S1 = (((max1-min1)*(0.72*l1))/2)+min1*l1; %calcul de la surfacia del triangulo m�s la de el rectangulo
%                                          %0.75*l1 = 75% de l1 (base)    
%S2 = (max2*(0.46*l2))/2; %calcul de la superficia del triangulo
%
%stmAP_1_medio = S1/l1;
%stmAP_2_medio = S2/l2;
%
%A1max = (deltaAP/gamma)*stmAP_1_medio;
%A2max = (deltaAP/gamma)*stmAP_2_medio;

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
nb_coop = zeros(Nses,Ntest);
contadorP1=0;
contadorP2=0;
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
        %P1(i,k)=0.5*(1-exp(-(5*A1((j-1)+Num,l))/A1max))+0.5; %probabilidad en exponential
        P=.8;
        %P2(i,k)=0.5*(1-exp(-(5*A2((j-1)+Num,l))/A2max))+0.5;
        
        a = rand ;
        %%% ELECCION DE LA PALANCA %%% Basicamente elige palanquear o no palanquear
        if (A1((j-1)+Num,l)<=limrand)&&(A2((j-1)+Num,l)<=limrand)
          palanca(i)=randi(2);
        elseif (A1((j-1)+Num,l)>=limrand)&&(A2((j-1)+Num,l)<=limrand)
          if a>=P
            palanca(i)=2;
          else
            palanca(i)=1;
          end
        elseif (A1((j-1)+Num,l)<=limrand)&&(A2((j-1)+Num,l)>=limrand)
          if a>=P
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
          stm_1(j+Num,l)=(1-beta)*stm_1((j-1)+Num,l)+alpha*Rf_1;
          stm_2(j+Num,l)=(1-beta)*stm_2((j-1)+Num,l)+alpha*Rf_2;
          contadorP1=0;
        end
      else
        contador=contador +1;
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
    
    for j = 1:Ntrial
      if palanca(j)==1
        %nb_coop(k-1,l)= nb_coop(k-1,l)+1;
        nb_coop(k,l)= nb_coop(k,l)+1;
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


porcentaje_coop_sesion=zeros(Nses,Ntest);
porcentaje_coop_experimento=zeros(Ntest,1);
for k = 1:Ntest
  porcentaje_coop_experimento(k)=sum(nb_coop(:,k))/(Ntrial*Nses)*100;
end

%for i=1:Ntest
%  terminal_sesion(1,i)=sesion(1,i);
%  for j=2:Nses
%    terminal_sesion(j,i)=sesion(j,i)+terminal_sesion(j-1,i);
%  end
%end

%%% DEMOSTRACION 


%promedio_sesion=sum(ird)/Ntest
porcent_10xsuperior_al_otra=porcent/Ntest * 100;
cuanto_alcanzan_al_maxima=sum(maxima)/Ntest * 100;
porcentaje_coop_experimento;
porcentaje_coop_sesion=floor(nb_coop/Ntrial*100);


for i=1:Ntest
  figure
  hold on
  plot((1:Sizemat)*tMuestreo,A1(:,i),'r',(1:Sizemat)*tMuestreo,A2(:,i),'b',(1:Sizemat)*tMuestreo,stm_1(:,i),'g',(1:Sizemat)*tMuestreo,stm_2(:,i),'m',(1:Sizemat)*tMuestreo,limrand*ones(1,length([1:Sizemat])),'--b')
  legend("A1","A2","STM1","STM2","limrand");
  for j=1:Nses
    %plot(sesion(j,i)*ones(1,max(max(A1(:,i)))),(1:max(max(A1(:,i)))),'--k');
    h=plot((sesion(j,i).*tMuestreo)*ones(1,max(max(A1(:,i)))),(1:max(max(A1(:,i)))),'--k');
    set(h, "linewidth", 2);
  end
end

color = 'rgbmkmrgbk';
figure
hold on
for i=1:Ntest
  plot(1:Nses,porcentaje_coop_sesion(:,i),'Color',color(i));
  title('Porcentaje de Cooperacion');
  xlabel('Numero de sesion');
  ylabel('Porcentaje');
end
hold off

%%% probl�me de temps, pas le temps de d�croitre du coup red�marre plus
%%% haut CQFD
%%%% CASTIGO DE TIEMPO 
%%%% CUANTO VECES ELIGE COOPERATION
%%% Pour chaque session r�cup�rer le nombre de coop�ration et tracer la
%%% courbe correspondante 

