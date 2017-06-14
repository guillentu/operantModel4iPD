n=1:100
lamda1=0.38;
rho=0.28;
lamda=lamda1*rho;
zeta=(1-exp(-lamda.*n));
a=123;
plot((zeta./rho-n./a));

