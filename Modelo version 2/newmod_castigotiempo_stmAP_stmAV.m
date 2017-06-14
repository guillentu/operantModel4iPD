%% SHORT TERM MEMORY RESPONSE - REWARD
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
%% qui marche pas a quelle vitesse s'eteint la stm, memoire courte - si on a plus de memoire, elle se décide plus vite

%% INICIALIZATION
%%%%%% CONSTANTES DE DECAE / SUBE
alphaAP = 0.5 ;
betaAP  = 0.125 ;
alphaAV = 0.25 ;
betaAV  = 0.125 ;
gamma = 0.00134;%0.0067 ;
deltaAP = 0.5 ;
deltaAV = 0.5 ;

P = 0.8;

%%%%%% CONSTANTES DE SESIONES
Ntrial  =  30 ;
Nses    =  15 ;
Ntest   =  5;
limrand =  11;
saving  =  0.9 ;

%%%%%% INICIALIZACION
palanca = zeros(2,1);
Rf_1=zeros(10,1);
Rf_2=zeros(10,1);
A1=zeros(1,Ntest);
A2=zeros(1,Ntest);
stmAP_1=zeros(2,Ntest);
stmAP_2=zeros(2,Ntest);
stmAV_1=zeros(2,Ntest);
stmAV_2=zeros(2,Ntest);
d=1;
xAP_1=zeros(30,1);
xAP_2=zeros(30,1);
xAV_1=zeros(30,1);
xAV_2=zeros(30,1);
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
      stmAP_1(Num+1,l)=saving*stmAP_1(Num,l);
      stmAP_2(Num+1,l)=saving*stmAP_2(Num,l);
      stmAV_1(Num+1,l)=saving*stmAV_1(Num,l);
      stmAV_2(Num+1,l)=saving*stmAV_2(Num,l);
      %%% ELECCION DE LA PRIMERA PALANCA 
      if A1(Num,1)>A2(Num,1)
        palanca(2)=1;
      else
        palanca(2)=2;
      end
    end       
    
    for j=2:1000
      if contador == duracion(i)+d
        contador = 1;
        
        i = i+1 ;
        
        a = rand ;
        
        %%% ELECCION DE LA PALANCA %%%
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
        elseif (A1((j-1)+Num,l)>=limrand)&&(A2((j-1)+Num,l)>=limrand)
          if (abs(A1((j-1)+Num,l)-A2((j-1)+Num,l))>1)
            if (A1((j-1)+Num,l)>A2((j-1)+Num,l))
              if a>=P
                palanca(i)=2;
              else
                palanca(i)=1;
              end
            else 
              if a>=P
                palanca(i)=1;
              else
                palanca(i)=2;
              end
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
          xAP_1=[ones(1,Rf_1(i)),zeros(1,4*duracion(i)),0,0];
          xAP_2=[zeros(1,Rf_1(i)),zeros(1,4*duracion(i)),0,0];
          xAV_1=[zeros(1,Rf_1(i)),zeros(1,4*duracion(i)),0,0];
          xAV_2=[zeros(1,Rf_1(i)),zeros(1,4*duracion(i)),0,0];
        elseif (palanca(i)==1)&&(palanca(i-1)==2) %% S + 8s
          d=8;
          xAP_1=[zeros(1,d),zeros(1,4*duracion(i)),0,0];
          xAP_2=[zeros(1,d),zeros(1,4*duracion(i)),0,0];
          xAV_1=[ones(1,d),zeros(1,4*duracion(i)),0,0];
          xAV_2=[zeros(1,d),zeros(1,4*duracion(i)),0,0];
        elseif (palanca(i)==2)&&(palanca(i-1)==2) %% P + 4s
          d=4;
          xAP_1=[zeros(1,d),zeros(1,4*duracion(i)),0,0];
          xAP_2=[zeros(1,d),zeros(1,4*duracion(i)),0,0];
          xAV_1=[zeros(1,d),zeros(1,4*duracion(i)),0,0];
          xAV_2=[ones(1,d),zeros(1,4*duracion(i)),0,0];
        elseif (palanca(i)==2)&&(palanca(i-1)==1) %% T + 2p
          Rf_1(i)=0;
          Rf_2(i)=floor(10*(1-exp(-0.8* 2 )));
          d=Rf_2(i);
          xAP_1=[zeros(1,Rf_2(i)),zeros(1,4*duracion(i)),0,0];
          xAP_2=[ones(1,Rf_2(i)),zeros(1,4*duracion(i)),0,0];
          xAV_1=[zeros(1,Rf_2(i)),zeros(1,4*duracion(i)),0,0];
          xAV_2=[zeros(1,Rf_2(i)),zeros(1,4*duracion(i)),0,0];
        end
        
      else
        contador=contador +1;
      end
      
      stmAP_1(j+Num,l)=(1-betaAP)*stmAP_1((j-1)+Num,l)+alphaAP*xAP_1(contador);
      stmAP_2(j+Num,l)=(1-betaAP)*stmAP_2((j-1)+Num,l)+alphaAP*xAP_2(contador);
      
      stmAV_1(j+Num,l)=(1-betaAV)*stmAV_1((j-1)+Num,l)+alphaAV*xAV_1(contador);
      stmAV_2(j+Num,l)=(1-betaAV)*stmAV_2((j-1)+Num,l)+alphaAV*xAV_2(contador);
      
      A1(j+Num,l)=(1-gamma)*A1((j-1)+Num,l)+deltaAP*stmAP_1(j+Num,l)-deltaAV*stmAV_1(j+Num,l);
      A2(j+Num,l)=(1-gamma)*A2((j-1)+Num,l)+deltaAP*stmAP_2(j+Num,l)-deltaAV*stmAV_2(j+Num,l);
      
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
  plot(1:Sizemat,A1(:,i),'r',1:Sizemat,A2(:,i),'b',1:Sizemat,stmAP_1(:,i),'g',1:Sizemat,stmAP_2(:,i),'m',1:Sizemat,-stmAV_1(:,i),'k',1:Sizemat,-stmAV_2(:,i),'c',1:Sizemat,limrand*ones(1,length([1:Sizemat])),'--b')
  legend("A1","A2","STMAP1","STMAP2","STMAV1","STMAV2","limrand");
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

%%% problème de temps, pas le temps de décroitre du coup redémarre plus
%%% haut CQFD
%%%% CASTIGO DE TIEMPO 
%%%% CUANTO VECES ELIGE COOPERATION
%%% Pour chaque session récupérer le nombre de coopération et tracer la
%%% courbe correspondante 

