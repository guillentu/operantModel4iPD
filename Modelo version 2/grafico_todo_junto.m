close all
clc
clear

%% INICIALIZATION
%%%%%% CONSTANTES DE SESIONES
Ntrial  =  1 ;   %% un trial de 3600 segundos
tTrial  =  3600; %% en segundos
tResp   =  1;    %% en segundos
tMuestreo = 0.25;%% en segundos
Nses    =  5 ;
Vi=[5,10,30,40,60]; %% valores medios de intervalos variables
Ntest   =  1;
limrand =  0.138;
saving  =  0.01 ;

load FI
load VI
load FR
load VR
load aFI
load aVI
load aFR
load aVR

figure
hold on
for i=1:Ntest
  plot(refuerzoFI(:,i),resp_por_segundosFI(:,i),'r',refuerzoFR(:,i),resp_por_segundosFR(:,i),'g',refuerzoVI(:,i),resp_por_segundosVI(:,i),'b',refuerzoVR(:,i),resp_por_segundosVR(:,i),'c');
  title('Respuestas y refuerzo');
  xlabel('Refuezo/horas');
  ylabel('Respuestas/segundos');
end
hold off



for i=1:Nses
  figure
  hold on
  plot(1:Ntrial*tTrial,cum_respFI(i,:),'r',1:Ntrial*tTrial,cum_respFR(i,:),'g',1:length(cum_respVI(i,:)),cum_respVI(i,:),'b',1:length(cum_respVR(i,:)),cum_respVR(i,:),'c');
  plot(aFI.(num2str(i)),cum_respFI(i,aFI.(num2str(i))),'k+',aFR.(num2str(i)),cum_respFR(i,aFR.(num2str(i))),'k+',aVI.(num2str(i)),cum_respVI(i,aVI.(num2str(i))),'k+',aVR.(num2str(i)),cum_respVR(i,aVR.(num2str(i))),'k+');
  title(strcat('Cumulative records sesion ',num2str(i)));
  xlabel('Time');
  ylabel('Cumulative responses');
  hold off
end
