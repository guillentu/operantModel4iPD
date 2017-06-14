alpha = 0.8 ;           %% constante de decaer 
N = 30;                 %% numeros de trials por sesiones
Ns = 10;                %% numeros de sesiones
ka = [0.35 0.34 0.33 0.32 0.31 0.30 .29 .28 .27 .26 .25];                 %% constante de decaer vinculado a la inactividad
Moy = 3;                % primero termo de la sesion i+1 = promedio hizo sobre Moy termos de la ultima ( Moy = numero )
a = 0.18;               % multiplica le refuerzo
facteur = 0.6;          % por ciento de lo que queda de la ultima sesion en la memoria ( == saving )
A = zeros(2,N*Ns);      
A(:,1) = 1;
T_1 = ones(N,1);        %% tiempo entre dos trials
T_2 = ones(N,1);

for tab=1:10
for figa = 1:6

for k = 1:Ns
    cpt_1 =0;
    cpt_2 =0;
    U = zeros(N,1);
    U(1)=0;
    V = zeros(N,1);
    V(1)=0;
    diviseur=zeros(6,1);
    levier = zeros(N,1);
    levier(1)=randi(2);
    levier(2)=randi(2);
    for j=1:6
        diviseur(j) = j*k;
    end
    
    for i =3:N
       
        
       %%% ELECCION DE LA PALANCA
       if ((levier(i-1)==1)&&(U(i-1)-U(i-2)-V(i-2)>=0))||((levier(i-1)==2)&&(V(i-1)-U(i-2)-V(i-2)<0));
           levier(i)=(floor(0.145*randi(7)))+1  ;
       elseif ((levier(i-1)==2)&&(V(i-1)-U(i-2)-V(i-2)>=0))||((levier(i-1)==1)&&(U(i-1)-U(i-2)-V(i-2)<0));
           levier(i)=abs((floor(0.145*randi(7)))-2);    
       end
       
       
       %%% CONTADOR PARA PALANCA NO USADA
       if levier(i) == 1
           cpt_1 = 0;
           cpt_2 = cpt_2 +1;
       else
           cpt_1 = cpt_1 +1;
           cpt_2 = 0;
       end  
              
       
       %%% REFUERZO    ( 6 4 1 0 EN PORCENTAJE  -  6 = 1 )
       if (levier(i)==1)&&(levier(i-1)==1)
           U(i)=0.6667;
           V(i)=0;
       elseif (levier(i)==1)&&(levier(i-1)==2)
           U(i)=0.05;
           V(i)=0;
       elseif (levier(i)==2)&&(levier(i-1)==2)
           U(i)=0;
           V(i)=0.1667;
       elseif (levier(i)==2)&&(levier(i-1)==1)
           U(i)=0;
           V(i)=1;
       end
       
       
       %% T - TIEMPO ENTRE DOS REFUERZOS
       if U(i-1)==0
           T_1(i) = T_1(i-1) + 1/5;
       else
           T_1(i)=1;
       end
     
       if V(i-1)==0
           T_2(i) = T_2(i-1) + 1/5;
       else
           T_2(i)=1;
       end
           
              
      %%% INICIALIZACION
      if k>1
        A(1,(k-1)*N+1)=sum(A(1,((k-1)*N-Moy):((k-1)*N)))/Moy*facteur; % primero termo de la nueva sesion
        A(2,(k-1)*N+1)=sum(A(2,((k-1)*N-Moy):((k-1)*N)))/Moy*facteur;
      end
      

      %%% ITERACION
       A(1,(k-1)*N+i) =  min( ... 
        ( A(1,(k-1)*N+1) )/alpha   ... primero termo / alpha cf libro
       *( 1-exp(-alpha*T_1(i)*(sum(U(1:i)+1))) ) ^ (levier(i)==1)   ... aprendizaje
       *( exp(-ka(tab)*cpt_1)*A(1,(k-1)*N+i-1)) ^ abs((levier(i)==1)-1)   ... disminucion vinculada a la inactividad
       * exp(a*U(i)) ... impacto del refuerzo
       ,1000); 
   
        A(2,(k-1)*N+i) =  min( ... 
        ( A(2,(k-1)*N+1) )/alpha   ... 
       *( 1-exp(-alpha*T_2(i)*(sum(V(1:i)+1))) ) ^ (levier(i)==2)   ... 
       *( exp(-ka(tab)*cpt_2)*A(2,(k-1)*N+i-1)) ^ abs((levier(i)==2)-1)   ... 
       * exp(a*V(i)) ...
       ,1000);
   

    end
end


figure(tab)
subplot(2,3,figa)   

plot(1:N*Ns,A(1,:),1:N*Ns,A(2,:));
xlabel('\bf{Numero del estimulo}','FontSize',12);
ylabel('\bf{Excitacion }','fontsize',12);
title('\bf{Excitacion / tiempo }','FontSize',14);
legend(sprintf('\\bf{Palanca 1}'),...
        sprintf('\\bf{Palanca 2}'),...
       'Location','Best');
   
end
end


Diff = zeros(1,N*Ns);
%for i=1:N*Ns
%    Diff(i)=abs(A(1,i)-A(2,i));
%end
%figure;
%plot(Diff)