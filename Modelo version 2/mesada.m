%n=1:100;
%lamda1=0.38;
%rho=0.28;
%lamda=lamda1*rho;
%zeta=(1-exp(-lamda.*n));
%a=123;
%plot((zeta./rho-n./a));
%hold on 
%plot(zeta,'r')
%hold off

%figure;
%taU=10;
%plot(exp(-[0:100]/10));
%aux(1)=1;
%for i=2:100
%  aux(i)=(1-1/taU)*aux(i-1);
%endfor
%hold on;
%h=plot(aux,'-.r');
%set(h, 'linewidth',2);
%%set(h, "linewidth", 2);
%hold off;


%%               
for i=1:Ntest
  for j=1:Nses
    figure
    hold on
    if j==1
      abscisa=[1:sesion(j,i)]*tMuestreo;
      abscisa2=[1:sesion(j,i)];
      h=plot(0:sesion(j,i)/4,P(:,j)'*A1max,'.--m');
    else
      abscisa=[1:sesion(j,i)]*tMuestreo;
      abscisa2=[sesion(j-1,i)-1:sesion(j,i)]

      h=plot(sesion(j-1,i)/4:sesion(j,i)/4,P(:,j)'*A1max,'.--m');
    endif
    plot(abscisa,A1(abscisa2,i),'r',...
         abscisa,A2(abscisa2,i),'b',...
         abscisa,stm_1(abscisa2,i),'g',...
         abscisa,stm_2(abscisa2,i),'m',...
         abscisa,limrand*ones(1,length(abscisa)),'--b');
         
    legend("A1","A2","STM1","STM2","limrand");

    h=plot(1:sesion(j,i)/4,P(1:length(abscisa)/4,j)'*A1max,'.--m');
    h=plot(abscisa*ones(1,max(max(A1(:,i)))),(1:max(max(A1(:,i)))),'--k');
    set(h, "linewidth", 2);
    %plot(abscisa/4,A1max*ones(1,sesion(1,i)*tMuestreo))
    hold off;
  endfor
endfor