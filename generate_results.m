%%% Script para gerar os resultados dos 3 algoritmos simulados
%%% Gera a alocação media de bits por subportadora.

%% Loading static.mat
SimData=load('static.mat');
staticSNR   = SimData.Static.DataSNR;
staticBPRB  = SimData.Static.DataBPRB; 
% Loading dynamicMaxVazao.mat
DynamicData=load('dynamicMaxVazao.mat');
dynamicSNR   = DynamicData.Dynamic.DataSNR;
dynamicBPRB  = DynamicData.Dynamic.DataBPRB;
% Loanding dynamicAWM.mat
DynamicAWM_Data=load('dynamicAWM.mat'); 
dynamicAWM_SNR   = DynamicAWM_Data.DynamicAWM.DataSNR;
dynamicAWM_BPRB  = DynamicAWM_Data.DynamicAWM.DataBPRB;


%% Gera graficos de Média de Bits/SNR
figure;
plot(staticSNR, staticBPRB, '-.b*');

%plot(dynamicAWM_SNR, dynamicAWM_BPRB, '-sk','MarkerFaceColor',[.09 1 .0],'LineWidth',1.1);
%title('Resource Allocation in Orthogonal Multiple Access Systems');
xlabel('SNR [dB]'); 
ylabel('Average Bits per Subcarrier'); 
grid on;
grid minor;

hold on;
plot(dynamicSNR, dynamicBPRB, '-.r*');
hold on;
plot(dynamicAWM_SNR, dynamicAWM_BPRB, '-sk','MarkerFaceColor',[.09 1 .0],'LineWidth',1.1);
legend('Static Allocation', 'Dynamic WA - Max. Throughtput', 'Dynamic MWA-MOM');
