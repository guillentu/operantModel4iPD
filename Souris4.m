close all;
clear all;

T = 1;
alpha=zeros(10,1);
for i = 1:10
    alpha(i) = 4+i/10;
end

N = 30;
Ns = 8;
ka = 1.2;
Moy = 5;
a = 0.01;
facteur = 0.4;
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
    levier = zeros(N,1);
    levier(1)=randi(2);
    levier(2)=randi(2); 
    
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
       
       for kkk=1:N/2
          U(2*kkk)= 4;
          U(2*kkk-1)= 0;
          V(2*kkk)= 6;
          V(2*kkk-1)=1;
       end
       
       
      if k>1
        A(1,(k-1)*N+1)=sum(A(1,((k-1)*N-Moy):((k-1)*N)))/Moy*facteur; % proportion retenue de l'exp précédente
        A(2,(k-1)*N+1)=sum(A(2,((k-1)*N-Moy):((k-1)*N)))/Moy*facteur;
      end
      
      
       A(1,(k-1)*N+i) =   ... 
        ( A(1,(k-1)*N+1)/alpha(tab)/T )   ... terme initial session
       *( 1-exp(-alpha(tab)*T*sum(U(1:i))) ) ^ (levier(i)==1)   ... apprentissage
       *( exp(-ka*cpt_1)*A(1,(k-1)*N+i-1)) ^ abs((levier(i)==1)-1)   ... décroissance si non usité
       * exp(U(i)*a); % impact du CS 
   
        A(2,(k-1)*N+i) =   ...
        ( A(2,(k-1)*N+1)/(alpha(tab)*T) )   ...
       *( 1-exp(-alpha(tab)*T*sum(V(1:i))) ) ^ (levier(i)==2)   ...
       *( exp(-ka*cpt_2)*A(2,(k-1)*N+i-1))^abs((levier(i)==2)-1)   ...
       * exp(V(i)*a);
    
    
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







