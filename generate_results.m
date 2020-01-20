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
plot(dynamicAWM_SNR, dynamicAWM_BPRB, '-ok','LineWidth',1.1);
title('Alocação de Recursos em sistema de multiplo acesso Ortogonal');
xlabel('SNR [dB]'); 
ylabel('Bits/Subportadora'); 
grid on;
grid minor;

hold on;
plot(dynamicSNR, dynamicBPRB, '--b');
hold on;
plot(staticSNR, staticBPRB, '--r');
legend('Water-filling Modificado - MOM', 'Dinamica - Máx. Vazão', 'Alocação Estática');
