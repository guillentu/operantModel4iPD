T = 1;                  %%temps entre deux trials (s)
alpha = 0.48;           %%constante décroissance LTM
N = 30;                 %%nombre d'essais par session
Ns = 10;                %%nombre de sessions
ka = 3;                %%constante décroissance liée à l'inactivité
Moy = 3;                %premier terme session i+1 = moyenne sur Moy terme
a = [1.08,0.085,0.086,0.087,0.09,0.095,0.1,0.11,0.12,0.14];               %multiplie le gain
facteur = 0.4;          %ce qu'il reste de la session précédente
A = zeros(2,N*Ns);      
A(:,1) = 1;

for tab=1:10
for figa = 1:6

for k = 1:Ns
    cpt_1 =0;
    cpt_2 =0;
    U = zeros(N,1);
    U(1)=4;
    V = zeros(N,1);
    V(1)=6;
    diviseur=zeros(6,1);
    levier = zeros(N,1);
    levier(1)=randi(2);
    levier(2)=randi(2);
    for j=1:6
        diviseur(j) = j*k;
    end
    
    for i =3:N
      
       if ((levier(i-1)==1)&&(U(i-1)-U(i-2)-V(i-2)>=0))||((levier(i-1)==2)&&(V(i-1)-U(i-2)-V(i-2)<0));
           levier(i)=(floor(0.145*randi(7)))+1  ;
       elseif ((levier(i-1)==2)&&(V(i-1)-U(i-2)-V(i-2)>=0))||((levier(i-1)==1)&&(U(i-1)-U(i-2)-V(i-2)<0));
           levier(i)=abs((floor(0.145*randi(7)))-2);    
       end
           
           
       if levier(i) == 1
           cpt_1 = 0;
           cpt_2 = cpt_2 +1;
       else
           cpt_1 = cpt_1 +1;
           cpt_2 = 0;
       end  
       
       
       if levier == 1
           p = rand;                %%%%%%
           if (0.5>p)&&(p>0);  %%%% REWARD %%%% 
               U(i)=5;             %%%%%%
           elseif (1>p)&&(p>0.5);
               U(i)=3;             %%%%%%
           end
       else p = rand;
           if (0.5>p)&&(p>0);
               V(i)=0;              %%%%%%
           elseif (1>p)&&(p>0.5);
               V(i)=1.02;           %%%%%%
           end
        
       end
       
       
      if k>1
        A(1,(k-1)*N+1)=sum(A(1,((k-1)*N-Moy):((k-1)*N)))/Moy*facteur; % proportion retenue de l'exp précédente
        A(2,(k-1)*N+1)=sum(A(2,((k-1)*N-Moy):((k-1)*N)))/Moy*facteur;
      end
      
       A(1,(k-1)*N+i) =   ... 
        ( A(1,(k-1)*N+1) )/alpha/T   ... terme initial session
       *( 1-exp(-alpha*T*(sum(U(1:i)/2))) ) ^ (levier(i)==1)   ... apprentissage
       *( exp(-ka*(cpt_1/2))*A(1,(k-1)*N+i-1)) ^ abs((levier(i)==1)-1)   ... décroissance si non usité
       * exp(U(i)*a(tab)); % impact du CS 
   
        A(2,(k-1)*N+i) =   ... 
        ( A(2,(k-1)*N+1) )/alpha/T   ... terme initial session
       *( 1-exp(-alpha*T*(sum(V(1:i)/2))) ) ^ (levier(i)==2)   ... apprentissage
       *( exp(-ka*(cpt_2/2))*A(2,(k-1)*N+i-1)) ^ abs((levier(i)==2)-1)   ... décroissance si non usité
       * exp(V(i)*a(tab)); % impact du CS     
    end
   
    %%%
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
figure;
plot(Diff)