%% SHORT TERM MEMORY RESPONSE - REWARD
%% Castigos

%Cambiar el calculo de A1max y A2max porque ahora el refuerzo est� directo

close all
clc
clear

function rf = feel(pellets)
  rf=0;
  if (nargin~=0)
    rf=(12.8*(1-exp(-.25.* pellets.^(2))))+(12.8*(1-exp(-.5.* pellets)));
  else
    error ("Faltan parametros");
  endif
endfunction

%% INICIALIZATION
%%%%%% CONSTANTES DE DECAE / SUBE
alphaAP = 0.5 ;
betaAP  = 0.125 ;
alphaAV = 0.25 ;
betaAV  = 0.125 ;
gamma = 0.0067; %0.00134; %0.0067;  %2/1 sesiones
deltaAP = 0.5 ;
deltaAV = 0.125 ;
deltaAV2 = 0.25 ;

tau = 0.8 ;
R1 = floor(feel(1)); %tiempo de refuezo para R
R2 = floor(feel(2)); %tiempo de refuezo para T

l1 = 21; %20 = duraci�n entre trials
l2 = 42; %42 = 1 de refuerzo + 20 entre trials + 1 de castigo + 20 entre trials

max1 = 0; %maximum de stm1
min1 = 0; %minimum de stm1
for i = 1:10
  max1 = min1*(1-betaAP)+alphaAP*R1;
  min1 = max1*(1-betaAP)^20;
end

max2 = alphaAP*R2; %maximum de stm2

S1 = (((max1-min1)*(0.72*l1))/2)+min1*l1; %calcul de la surfacia del triangulo m�s la de el rectangulo
                                          %0.75*l1 = 75% de l1 (base)    
S2 = (max2*(0.46*l2))/2; %calcul de la superficia del triangulo

stmAP_1_medio = S1/l1;
stmAP_2_medio = S2/l2;

A1max = (deltaAP/gamma)*stmAP_1_medio;
A2max = (deltaAP/gamma)*stmAP_2_medio;

%%%%%% CONSTANTES DE SESIONES
Ntrial  =  30 ;
Nses    =  15 ;
Ntest   =  5 ;
saving  =  0.8 ;

%%%%%% INICIALIZACION
palanca = zeros(2,1);
RfAP_1=zeros(10,1);
RfAP_2=zeros(10,1);
RfAV_1=zeros(10,1);
RfAV_2=zeros(10,1);
A1=zeros(1,Ntest);
A2=zeros(1,Ntest);
stmAP_1=zeros(1,Ntest);
stmAP_2=zeros(1,Ntest);
stmAV_1=zeros(1,Ntest);
stmAV_2=zeros(1,Ntest);
sesion = zeros(Nses,1);
nb_coop = zeros(Nses,Ntest);


%% INICIO DE LAS ITERATIONS
for l = 1:Ntest
  Num=0;
  for k = 1:Nses
    i=2;
    duracion = [1,1,20*ones(1,Ntrial+2)];
    d = 1;
    contador = 2;
    palanca(1)=1;
    
    if k>1
      A1(Num+1,l)=saving*A1(Num,l);
      A2(Num+1,l)=saving*A2(Num,l);
      stmAP_1(Num+1,l)=0*stmAP_1(Num,l);
      stmAP_2(Num+1,l)=0*stmAP_2(Num,l);
      stmAV_1(Num+1,l)=0*stmAV_1(Num,l);
      stmAV_2(Num+1,l)=0*stmAV_2(Num,l);
    end       
    
    for j=2:1000
      if contador == duracion(i) + d
        contador = 1 ;
        
        i = i+1 ;
        J = j ;
        
        P1(i,k)=0.5*(1-exp(-(5*A1((j-1)+Num,l))/A1max))+0.5; %probabilidad en exponential
        P2(i,k)=0.5*(1-exp(-(5*A2((j-1)+Num,l))/A2max))+0.5;

%        P1(i,k)=0.5*((A1((j-1)+Num,l)/A1max)+1); %probabilidad en linear
%        P2(i,k)=0.5*((A2((j-1)+Num,l)/A2max)+1);
        
        a = rand ;
        
        %%% ELECCION DE LA PALANCA %%%
        if abs(A1((j-1)+Num,l)-A2((j-1)+Num,l))<1
          palanca(i-1)=randi(2);
        else
          if A1((j-1)+Num,l)>A2((j-1)+Num,l)
            if a>=P1(i,k)
              palanca(i-1)=2;
            else
              palanca(i-1)=1;
            end
          else
            if a>=P2(i,k)
              palanca(i-1)=1;
            else
              palanca(i-1)=2;
            end
          end
        end

        %%% REFUERZO %%%
           %  Experimental     Oponente
        if (palanca(i-1)==1)&&(palanca(i-2)==1) %% R + 1p
          RfAP_1(i)=floor(feel(1));
          RfAP_2(i)=0;
          RfAV_1(i)=0;
          RfAV_2(i)=0;
          d=RfAP_1(i);
        elseif (palanca(i-1)==1)&&(palanca(i-2)==2) %% S + 8s
          RfAP_1(i)=0;
          RfAP_2(i)=0;
          RfAV_1(i)=8;
          RfAV_2(i)=0;
          d=8;
        elseif (palanca(i-1)==2)&&(palanca(i-2)==2) %% P + 4s
          RfAP_1(i)=0;
          RfAP_2(i)=0;
          RfAV_1(i)=0;
          RfAV_2(i)=4;
          d=4;
        elseif (palanca(i-1)==2)&&(palanca(i-2)==1) %% T + 2p
          RfAP_1(i)=0;
          RfAP_2(i)=floor(feel(2));
          RfAV_1(i)=0;
          RfAV_2(i)=0;
          d=RfAP_2(i);
        end
        
      else
        contador=contador+1;
        RfAP_1(i)=0;
        RfAP_2(i)=0;
        RfAV_1(i)=0;
        RfAV_2(i)=0;
      end
      
      stmAP_1(j+Num,l)=(1-betaAP)*stmAP_1((j-1)+Num,l)+alphaAP*RfAP_1(i);
      stmAP_2(j+Num,l)=(1-betaAP)*stmAP_2((j-1)+Num,l)+alphaAP*RfAP_2(i);
      
      stmAV_1(j+Num,l)=(1-betaAV)*stmAV_1((j-1)+Num,l)+alphaAV*RfAV_1(i);
      stmAV_2(j+Num,l)=(1-betaAV)*stmAV_2((j-1)+Num,l)+alphaAV*RfAV_2(i);
      
      A1(j+Num,l)=(1-gamma)*A1((j-1)+Num,l)+deltaAP*stmAP_1(j+Num,l)-deltaAV*stmAV_1(j+Num,l);
      A2(j+Num,l)=(1-gamma)*A2((j-1)+Num,l)+deltaAP*stmAP_2(j+Num,l)-deltaAV2*stmAV_2(j+Num,l);
      
      if i==Ntrial+2
        if j==J+d+19
          break
        end
      end
      
    end
    
    %%% CONTADOR DE A QUE J SE CAMBIA LA SESION
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

%%% PRUEBA IV _ CONVIERTE J EN NUMERO DE SESION
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


%%% DEMOSTRACION 


%promedio_sesion=sum(ird)/Ntest
porcent_10xsuperior_al_otra=porcent/Ntest * 100;
cuanto_alcanzan_al_maxima=sum(maxima)/Ntest * 100;
porcentaje_coop_experimento;
porcentaje_coop_sesion=floor(nb_coop/Ntrial*100);


for i=1:5
  figure
  hold on
  plot(1:Sizemat,A1(:,i),'r',1:Sizemat,A2(:,i),'b',1:Sizemat,stmAP_1(:,i),'g',1:Sizemat,stmAP_2(:,i),'m',1:Sizemat,-stmAV_1(:,i),'k',1:Sizemat,-stmAV_2(:,i),'c')
  legend("A1","A2","STMAP1","STMAP2","STMAV1","STMAV2");
  for j=1:Nses
    plot(sesion(j,i)*ones(1,max(max(A1(:,i)),max(A2(:,i)))),(1:max(max(A1(:,i)),max(A2(:,i)))),'--k');
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
