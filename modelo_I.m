
N=400; %evolucion
n=5;
T=[0.1*ones(1,N/n) 0.4*ones(1,N/n) 0.6*ones(1,N/n) 0.4*ones(1,N/n) 0*ones(1,N/n)];
alfa=0.1;
tau=zeros(1,N);
for i=2:N
  tau(i)=alfa*T(i)+(1-alfa)*tau(i-1);
endfor

plot(tau);

