T = 1;
alpha = 0.37;
q = 0.4;
d = 10;
N = 50;
Ns = 8;
ka = 3;
Moy = 5;
a = 0.05;
facteur = 0.3;
A = zeros(2,N*Ns);
A(:,1) = 2;

for tab=1:10
for figa = 1:6

for k = 1:Ns
    cpt_1 =0;
    cpt_2 =0;
    U = zeros(N,1);
    U(1)=1;
    V = zeros(N,1);
    V(1)=1;
    
    for i =2:N
       levier = randi(2); %%% COMPTEUR POUR DECROISSANCE LIEE A L'INACTIVITE
       if levier == 1
           cpt_1 = 0;
           cpt_2 = cpt_2 +1;
       else
           cpt_1 = cpt_1 +1;
           cpt_2 = 0;
       end  
       
       if levier == 1
           p = rand;                %%%%%%
           if (0.5>p)&&(p>0);  %%%% REWARD %%%% 
               U(i)=15;             %%%%%%
           elseif (1>p)&&(p>0.5);
               U(i)=12;             %%%%%%
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
        ( A(1,(k-1)*N+1)/alpha/T )   ... terme initial session
       *( 1-exp(-alpha*T*sum(U(1:i))) ) ^ (levier==1)   ... apprentissage
       *( exp(-ka*cpt_1)*A(1,(k-1)*N+i-1) ) ^ abs((levier==1)-1)   ... décroissance si non usité
       * exp(U(i)*a); % impact du CS 
   
        A(2,(k-1)*N+i) =   ...
        ( A(2,(k-1)*N+1)/(alpha*T) )   ...
       *( 1-exp(-alpha*T*sum(V(1:i))) ) ^ (levier==2)   ...
       *( exp(-ka*cpt_2)*A(2,(k-1)*N+i-1))^abs((levier==2)-1)   ...
       * exp(V(i)*a);
    
    
    end
    
        % Ajouter un compteur qui fait en sorte que le levier non utilis?
        % d?croit du nombre de tours jusqu'a ce qu'il soit utilis? ( ou
        % mettre du temps pour lisser les courbes, le compteur
        % correspondant ? une moyenne en fin de tour ? ) 
        
        
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







