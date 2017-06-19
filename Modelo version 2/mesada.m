%n=1:100;
%lamda1=0.38;
%rho=0.28;
%lamda=lamda1*rho;
%zeta=(1-exp(-lamda.*n));
%a=123;
%plot((zeta./rho-n./a));
%hold on 
%plot(zeta,'r')
%hold off

%figure;
%taU=10;
%plot(exp(-[0:100]/10));
%aux(1)=1;
%for i=2:100
%  aux(i)=(1-1/taU)*aux(i-1);
%endfor
%hold on;
%h=plot(aux,'-.r');
%set(h, 'linewidth',2);
%%set(h, "linewidth", 2);
%hold off;


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
nb_coop = zeros(Nses,Ntest);
contadorP1=0;
contadorP2=0;

%% CALCULO DE AROUSAL MAXIMO
%% Iteraciones de respuesta refuerzo para encotnrar el STM medio
Nconfig=30; %% Tasa de respuesta de configuracion
%plot([1:0.01:20],(12.8*(1-exp(-.25.* [1:0.01:20].^(2))))+(12.8*(1-exp(-.5.* [1:0.01:20]))),'.k')
R1 = floor(feel(1)); %tiempo de refuezo para R
l1 = Nconfig/tMuestreo; % duracion entre trials
iter=100; %% numero de iteraciones para que converja el stm
max1 = 0; %maximum de stm1
min1 = 0; %minimum de stm1
suma = 0; %suma es un valor necesaria para calcular max1 y min1
suma = alpha*R1 %% Refuerzo cada N respuestas
for i = 1:iter 
  suma = (1-beta)^(Nconfig/tMuestreo)*suma;%% Instantes que decae el stm
  min1=suma;
  suma += alpha*R1; %Refuerzo
  max1=suma;
end
comp=.5;
S1 = (((max1-min1)*(comp*l1))/2)+min1*comp*l1; %calcul de la superficie del triangulo mas la de el rectangulo
stm_1_medio = S1/(l1);
A1max = (delta/gamma)*stm_1_medio;