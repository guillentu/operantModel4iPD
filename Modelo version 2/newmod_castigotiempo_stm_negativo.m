%% SHORT TE1/RM MEMORY RESPONSE - REWARD
%% 30 sessions de 30 trials
%% Changer les 10 premiers termes faire un duracion(i)
%% Castigos  

close all
clc
clear

%% D'abord avec la matrice 0 1 4 6  
%% 1 - Faire varier limrand - 1000 simulations, % de souris qui atteignent le maximum selon un random pour des couples alpha beta gamma delta constants
%%% ou alors au bout de combien de trials on sort de la zone de turbulence
%%% 

%% 2 - On fait varier beta - On choisit un limrand qui marche un median un
%% qui marche pas a quelle vitesse s'eteint la stm, memoire courte - si on a plus de memoire, elle se d�cide plus vite

%% INICIALIZATION
%%%%%% CONSTANTES DE DECAE / SUBE
alpha = 0.5 ;
beta  = 0.125 ;
gamma = 0.025 ; 
delta = 0.5 ;

%%%%%% CONSTANTES DE SESIONES
Ntrial  =  30 ;
Nses    =  15 ;
Ntest   =  5;
limrand =  0.138;
saving  =  0.9 ;

%%%%%% INICIALIZACION
palanca = zeros(2,1);
Rf_1=zeros(10,1);
Rf_2=zeros(10,1);
A1=zeros(1,Ntest);
A2=zeros(1,Ntest);
stm_1=zeros(2,Ntest);
stm_2=zeros(2,Ntest);
d=1;
x_1=zeros(30,1);
x_2=zeros(30,1);
sesion = zeros(Nses,1);
terminal_sesion=zeros(Nses,1);
nb_coop = zeros(Nses,Ntest);

%% INICIO DE LAS ITERATIONS
for l = 1:Ntest
  Num=0;
  for k = 2:Nses+1
    Rf_1(1)=6;
    Rf_2(1)=6;
    i=2;
    duracion = [1,20*ones(1,Ntrial)];
    contador = 1;
    palanca(1)=1;
    palanca(2)=randi(2);
    
    if k>2
      A1(Num+1,l)=A1(Num,l);
      A2(Num+1,l)=A2(Num,l);
      stm_1(Num+1,l)=saving*stm_1(Num,l);
      stm_2(Num+1,l)=saving*stm_2(Num,l); 
      %%% ELECCION DE LA PRIMERA PALANCA 
      if stm_1(Num,1)>stm_2(Num,1)
        palanca(2)=1;
      else
        palanca(2)=2;
      end
    end       
    
    for j=2:1000
      if contador == duracion(i)+d
        contador = 1;
        
        i = i+1 ;
        
        %%% ELECCION DE LA PALANCA %%%
        if (stm_1((j-1)+Num,l)<=limrand)&&(stm_2((j-1)+Num,l)<=limrand)
          palanca(i)=randi(2);
        elseif (stm_1((j-1)+Num,l)>=limrand)&&(stm_2((j-1)+Num,l)<=limrand)
          palanca(i)=1;
        elseif (stm_1((j-1)+Num,l)<=limrand)&&(stm_2((j-1)+Num,l)>=limrand)
          palanca(i)=2;
        elseif (stm_1((j-1)+Num,l)>=limrand)&&(stm_2((j-1)+Num,l)>=limrand)
          if (abs(stm_1((j-1)+Num,l)-stm_2((j-1)+Num,l))>1)
            if (stm_1((j-1)+Num,l)>stm_2((j-1)+Num,l))
              palanca(i)=1;
            else 
              palanca(i)=2;
            end
          else
            palanca(i)=randi(2);
          end
        end
      
        %%% REFUERZO %%%
        if (palanca(i)==1)&&(palanca(i-1)==1) %% R + 1p
          Rf_1(i)=floor(10*(1-exp(-0.8* 1 )));
          Rf_2(i)=0;
          d=Rf_1(i);
          x_1=[ones(1,Rf_1(i)),zeros(1,4*duracion(i)),0,0];  
          x_2=[zeros(1,Rf_1(i)),zeros(1,4*duracion(i)),0,0];
        elseif (palanca(i)==1)&&(palanca(i-1)==2) %% S + 8s
          d=8;
          x_1=[-ones(1,d),zeros(1,4*duracion(i)),0,0];  
          x_2=[zeros(1,d),zeros(1,4*duracion(i)),0,0];
        elseif (palanca(i)==2)&&(palanca(i-1)==2) %% P + 4s
          d=4;
          x_1=[zeros(1,d),zeros(1,4*duracion(i)),0,0];  
          x_2=[-ones(1,d),zeros(1,4*duracion(i)),0,0];
        elseif (palanca(i)==2)&&(palanca(i-1)==1) %% T + 2p
          Rf_1(i)=0;
          Rf_2(i)=floor(10*(1-exp(-0.8* 2 )));
          d=Rf_2(i);
          x_1=[zeros(1,Rf_2(i)),zeros(1,4*duracion(i)),0,0];  
          x_2=[ones(1,Rf_2(i)),zeros(1,4*duracion(i)),0,0];
        end
      else
        contador=contador +1;
      end
      
      stm_1(j+Num,l)=(1-beta)*stm_1((j-1)+Num,l)+alpha*x_1(contador);
      stm_2(j+Num,l)=(1-beta)*stm_2((j-1)+Num,l)+alpha*x_2(contador);
      
      A1(j+Num,l)=(1-gamma)*A1((j-1)+Num,l)+delta*stm_1(j+Num,l);
      A2(j+Num,l)=(1-gamma)*A2((j-1)+Num,l)+delta*stm_2(j+Num,l);
      
      if i==Ntrial
        break
      end
    end
    
    
    %%% CONTADOR DE A QUE J SE CAMBIA LA SESION
    sesion(k-1,l)=j;

    %%% DEFINICION DE NUM
    compteur = 0 ;
    for i=1:length(A1(:,l))
      if A1(i,l)~=0
        compteur = compteur +1;
      end
    end
    Num=compteur;
    Sizemat = length(A1);
    
    for j = 1:Ntrial
      if palanca(j)==1
        nb_coop(k-1,l)= nb_coop(k-1,l)+1;
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
ird = zeros(Ntest,1);
for k = 1:Ntest
  i=1;
  while 1
    if A1(nonnul(k)-i,k) < limrand
      ird(k) = nonnul(k)-i+1;
      break;
    else
      i=i+1;
    end
  end
end

%%% PRUEBA IV _ CONVIERTE J EN NUMERO DE SESION
for k = 1:Ntest
  i=1;
  while 1
    if ird(k) <= sum(sesion(1:i)+50)
      ird(k)=i;
      break;
    else
      i=i+1;
    end
  end
end

%%% PRUEBA V _ PORCENTAJE DE COOPERACION POR SESION / EXPERIMENTO


porcentaje_coop_sesion=zeros(Nses,Ntest);
porcentaje_coop_experimento=zeros(Ntest,1);
for k = 1:Ntest
  porcentaje_coop_experimento(k)=sum(nb_coop(:,k))/(Ntrial*Nses)*100;
end





for i=1:Ntest
  terminal_sesion(1,i)=sesion(1,i);
  for j=2:Nses
    terminal_sesion(j,i)=sesion(j,i)+terminal_sesion(j-1,i);
  end
end





%%% DEMOSTRACION 


promedio_sesion=sum(ird)/Ntest
porcent_10xsuperior_al_otra=porcent/Ntest * 100
cuanto_alcanzan_al_maxima=sum(maxima)/Ntest * 100
porcentaje_coop_experimento
porcentaje_coop_sesion=floor(nb_coop/Ntrial*100)


for i=1:5
  figure
  hold on
  plot(1:Sizemat,A1(:,i),'r',1:Sizemat,A2(:,i),'b',1:Sizemat,stm_1(:,i),'g',1:Sizemat,stm_2(:,i),'m',1:Sizemat,limrand*ones(1,length([1:Sizemat])),'--b')
  legend("A1","A2","STM1","STM2","limrand");
  for j=1:Nses
    plot(terminal_sesion(j,i)*ones(1,max(max(A1(:,i)))),(1:max(max(A1(:,i)))),'--k');
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

