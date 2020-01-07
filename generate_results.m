%%% Script para gerar os resultados dos 3 algoritmos simulados
%%% Gera os histogramas com a distribuição dos bits alocados pelos usuários

%% Loading static.mat
SimData=load('static.mat');
staticSNR   = SimData.Static.DataSNR;
staticBPRB  = SimData.Static.DataBPRB; 
staticAlloc = SimData.Static.DataPDF; 
% Loading dynamicMaxVazao.mat
DynamicData=load('dynamicMaxVazao.mat');
dynamicSNR   = DynamicData.Dynamic.DataSNR;
dynamicBPRB  = DynamicData.Dynamic.DataBPRB;
dynamicAlloc = DynamicData.Dynamic.DataPDF;
% Loanding dynamicAWM.mat
DynamicAWM_Data=load('dynamicAWM.mat'); 
dynamicAWM_SNR   = DynamicAWM_Data.DynamicAWM.DataSNR;
dynamicAWM_BPRB  = DynamicAWM_Data.DynamicAWM.DataBPRB;
dynamicAWM_alloc = DynamicAWM_Data.DynamicAWM.DataPDF;


[counts,centers] = hist(dynamicAWM_alloc(10,:))
bar(centers,counts)

hold on 

