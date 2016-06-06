T =1;
alpha = 1;
q = 0;
d = 10;
Nb_session = 10;
N = 30;
A1 = zeros(Nb_session*N,length(T));
A2 = zeros(Nb_session*N,length(T));
A1(1,:)=1;
A2(1,:)=1;

hold on;
for m=1:length(T)
    for i=1:Nb_session
        U = zeros(1,N);
        if i>1
            A1((i-1)*N+1,m)=A1((i-1)*N,m)*(1-q*exp(-alpha*d));
        end
        for j=2:N
             if rand>0.4;
                U(j)=U(j-1)+1;
             else
                U(j)=U(j-1);
            end
            A1((i-1)*N+j,m)=A1((i-1)*N+1,m)/(alpha*T)*(1-exp(-alpha*T*m*U(j)));
        end
    end
end



for n=1:length(T)
	h = plot(1:Nb_session*N,A1(:,n),1:Nb_session*N,A1(:,n));
end