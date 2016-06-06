T =1;
alpha = 0.7;
q = 0.4;
d = 10;
N = 50;
Ns = 10;
k = 0.2;

A = zeros(2,N*Ns);
A(:,1) = 1;

U = sign(randn(1,N));
for j=2:N
     if rand>0.2;
        U(j)=U(j-1)+1;
     else
        U(j)=U(j-1)-1;
    end
end

for i = 1:Ns
    cpt_1 =0;
    cpt_2 =0;
    U = sign(randn(1,N));
    for j=2:N
         if (0.25>rand)&&(rand>0);
            U(j)=U(j-1)+0.33;
         elseif (0.5>rand)&&(rand>0.25);
            U(j)=U(j-1)+1.33;
         elseif (0.75>rand)&&(rand>0.5);
            U(j)=U(j-1)+0;
         elseif (1>rand)&&(rand>0.75);
            U(j)=U(j-1)+2;
         end
         % Modifier U pour ne pas qu'il y ait de zéro sur une même session
    end
    if i>1
        A(1,(i-1)*N+1)=A(1,(i-1)*N)*(1-q*exp(-alpha*d));
        A(2,(i-1)*N+1)=A(2,(i-1)*N)*(1-q*exp(-alpha*d));
    end
    for j =2:N
       levier = randi(2);
       A(1,(i-1)*N+j) = A(1,(i-1)*N+1)/alpha/T*((1-exp(-alpha*T*U(j)))^(levier==1))*exp(-k*abs((levier==1)-1)*T);
       A(2,(i-1)*N+j) = A(2,(i-1)*N+1)/alpha/T*((1-exp(-alpha*T*U(j)))^(levier==2))*exp(-k*abs((levier==2)-1)*T);
    end
    
        % Ajouter un compteur qui fait en sorte que le levier non utilisé
        % décroit du nombre de tours jusqu'a ce qu'il soit utilisé ( ou
        % mettre du temps pour lisser les courbes, le compteur
        % correspondant à une moyenne en fin de tour ? ) 
        
        
end

plot(1:N*Ns,A(1,:),1:N*Ns,A(2,:));
xlabel('\bf{Numero del estimulo}','FontSize',12);
ylabel('\bf{Excitacion }','fontsize',12);
title('\bf{Excitacion / tiempo }','FontSize',14);

legend(sprintf('\\bf{Palanca 1}'),...
        sprintf('\\bf{Palanca 2}'),...
       'Location','Best');









