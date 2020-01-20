%%% Simulação de alocação dinamica de usuarios em simbolo OFDM
%%% OFDMA with dynamic allocation - Water-filling maxima vazao do sistema

%% Water Filing para Maxima vazao do sistema


%% 
TargetSer = 1e-3;                           %% SER Alvo
N = 132;                                    %% Number of subcarriers
SNR = 0:2:44;                               %% SNR range
b = zeros(1,N);                             %% Vetor de Bits das portadoras
Total_bits = zeros(1,length(SNR));          %% Total de bits em um simbolo
bits_per_rb = zeros(1,length(SNR));         %% qtd media de Bits por subportadora 
nusers = 3;                                 %% Number of users
%% SNR gap para constelação M-QAM:
Gamma=(1/3)*qfuncinv(TargetSer/4)^2; % Gap to channel capacity M-QAM


%% 
%subPower = 20/1854; % 20 seria a potencia max do sistema de transmissao
% LTE EVA CHANNEL
freq_sample = 23.76e6;     %N*15e3; %30.72e6; sample rate do LTE
EVA_SR3072_Delay           =[0 30 150 310 370 710 1090 1730 2510].*1e-9;
EVA_SR3072_PowerdB_Gain    = [0 -1.5 -1.4 -3.6 -0.6 -9.1 -7 -12 -16.9]; %  20*log10(0.39)= -8.1787 => -8.1787 dB -> Voltage-ratio = 0.398107

chan_EVA = rayleighchan((1/(freq_sample)),0,EVA_SR3072_Delay,EVA_SR3072_PowerdB_Gain);        
impulse= [1; zeros(N - 1,1)];  


H    = ones(nusers,N);
mask = zeros(nusers,N);
capacity = zeros(nusers,N);

user_aloc = zeros(length(SNR),nusers);

num_itr = 3000;
for i=1:length(SNR)
    i
    j=0;
    while j<num_itr 
        
        % Gera o canal randomico para cada user
        for user=1:nusers
            h = filter(chan_EVA, impulse)';
            Hf = fft(h,N);
            H(user,:) = Hf;
        end
        
        SNRLIN = 10^(SNR(i)/10);
        P  = 20;
        Pu = P/nusers;
        
        for user=1:nusers
            mask(user,:) = ( abs(H(user,:))== max(abs(H)) ); % mask é 1 onde o user pode transmitir melhor
            [~,~, capacity(user,:) ] = fcn_waterfilling(Pu, P/(SNRLIN*N), Gamma, H(user,:), mask(user,:) );
        end

   
        b = sum(capacity);

        % Quantização
        b(b<2) = 0;
        b((b>2)&(b<4)) = 2;
        b((b>4)&(b<6)) = 4;
        b((b>6)&(b<8)) = 6;
        b(b>8) = 8;
        
        
        Total_bits(i) = Total_bits(i) + sum(b);        
        j = j+1;
    end  
    
    
    Total_bits(i) = Total_bits(i)/num_itr;
    bits_per_rb(i) = (Total_bits(i)/N); 
end

%% Loading File - Static data
SimData=load('static.mat');
D1 = SimData.Static.DataSNR;
D2 = SimData.Static.DataBPRB;  

%% Saving Vector Results in a File
Dynamic.DataSNR = SNR;   
Dynamic.DataBPRB = bits_per_rb;
FileName = strcat('C:\Users\alexrosa\Documents\MATLAB\POC_Resource_Allocation1\dynamicMaxVazao.mat'); 
save(FileName,'Dynamic');

%% Gera graficos de Bits/SNR
figure;
plot(SNR, bits_per_rb, '-o');
%title('Alocação de Recursos em sistema de multiplo acesso Ortogonal');
xlabel('SNR [dB]'); 
ylabel('Bits/Subportadoras'); 
grid on;
grid minor;

hold on;
plot(D1, D2, '-or');
legend('Alocação Dinâmica - Máxima Vazão','Alocação Estática');