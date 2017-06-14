a=zeros(1,1000);
gamma=1/8;
a(1)=1;
for i=2:1000
  a(i)=(1-gamma)*a(i-1);
endfor
endd=max(find(a>0.001));
figure;
plot(a(1:endd));
hold on;
plot(a(1)*(1-.63)*ones(1,endd));
hold off