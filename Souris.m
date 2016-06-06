T = 1;
alpha = 0.7;
A0 = 1;

N = 200;
U = zeros(1,N);
A = zeros(1,N);
A(1)= A0;

for i=2:200
    if rand>0.5;
        U(i)=U(i-1)+1;
    else
        U(i)=U(i-1)-1;
    end
    A(i) = A(1)/alpha/T*(1-exp(-alpha*T*U(i)));
end

plot(1:N,A);



