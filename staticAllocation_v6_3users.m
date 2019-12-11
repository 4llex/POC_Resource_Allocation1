%%% Simula��o de aloca��o estatica de usuarios em simbolo OFDM
%%% OFDMA with static allocation

%% Define Numerology
Numerology = 1;

if (Numerology == 1)
     N = 132;
     sc_per_rb = 48;
     RE = 1;
else
     N = 132;
     sc_per_rb = 12;
     RE = 1;
end

%%
TargetSer = 1e-3;                           %% SER Alvo
SNR = 0:2:40;                               %% XXX
%N = 6336;                                   %% Numero de Subportadoras
b = zeros(1,N);                             %% Vetor de Bits das portadoras / Numerologia 3
Total_bits = zeros(1,length(SNR));          %% Total de bits em um simbolo
bits_per_rb = zeros(1,length(SNR));         %% qtd media de Bits por RB 
quantizar = 'yes';                          %%
RB = 132;                                   %% qtd de RB
%sc_per_rb = 48;                            %% SubCarriers per RB, depends numerology  
nusers = 3;
%% SNR gap para constela��o M-QAM:
Gamma=(1/3)*qfuncinv(TargetSer/4)^2; % Gap to channel capacity M-QAM


%% 
%subPower = 20/1854; % 20 seria a potencia max do sistema de transmissao
% LTE EVA CHANNEL
freq_sample = 23.76e6;     %N*15e3; %30.72e6; sample rate do LTE
EVA_SR3072_Delay           = [0 30 150 310 370 710 1090 1730 2510].*1e-9;
EVA_SR3072_PowerdB_Gain    = [0 -1.5 -1.4 -3.6 -0.6 -9.1 -7 -12 -16.9]; %  20*log10(0.39)= -8.1787 => -8.1787 dB -> Voltage-ratio = 0.398107

chan_EVA = rayleighchan((1/(freq_sample)),0,EVA_SR3072_Delay,EVA_SR3072_PowerdB_Gain);        
impulse= [1; zeros(N - 1,1)];  

mask1 = [ones(1, 44), zeros(1, 132-44)];
mask2 = circshift(mask1, 44);
mask3 = circshift(mask2, 44);

H    = ones(nusers,N);
user_aloc = zeros(length(SNR),nusers);

num_itr = 100;
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
        Pu = P/3;
        
        [subPower1,~, subCapacity1 ] = fcn_waterfilling(Pu, P/(SNRLIN*RB), Gamma, H(user,:), mask1);
        [subPower2,~, subCapacity2 ] = fcn_waterfilling(Pu, P/(SNRLIN*RB), Gamma, H(user,:), mask2);
        [subPower3,~, subCapacity3 ] = fcn_waterfilling(Pu, P/(SNRLIN*RB), Gamma, H(user,:), mask3);
    
        b = subCapacity1 + subCapacity2 +  subCapacity3;

        % Quantiza��o
        b(b<2) = 0;
        b((b>2)&(b<4)) = 2;
        b((b>4)&(b<6)) = 4;
        b((b>6)&(b<8)) = 6;
        b(b>8) = 8;
%         b(b<0,083) = 0;
%         b((b>=0.083)&(b<0.167)) = 0.083;
%         b((b>=0.167)&(b<0.250)) = 0.167;
%         b((b>=0.250)&(b<0.333)) = 0.250;
%         b((b>=0.333)&(b<0.417)) = 0.333;
%         b((b>=0.417)&(b<0.583)) = 0.417;
%         b((b>=0.583)&(b<0.750)) = 0.583;
%         b((b>=0.750)&(b<0.833)) = 0.750;
%         b((b>=0.833)&(b<1.000)) = 0.833;
%         b((b>=1.000)&(b<1.166)) = 1.000;
%         b((b>=1.166)&(b<1.500)) = 1.166;
%         b((b>=1.500)&(b<1.833)) = 1.500;
%         b((b>=1.833)&(b<2.167)) = 1.833;
%         b((b>=2.167)&(b<2.500)) = 2.167;
%         b((b>=2.500)&(b<3.000)) = 2.500;
%         b((b>=3.000)&(b<3.333)) = 3.000;
%         b((b>=3.333)&(b<3.500)) = 3.333;
%         b((b>=3.500)&(b<4.000)) = 3.500;
%         b((b>=4.000)&(b<4.500)) = 4.000;
%         b((b>=4.500)&(b<4.750)) = 4.500;
%         b((b>=4.750)&(b<5.250)) = 4.750;
%         b((b>=5.250)&(b<5.500)) = 5.250;
%         b((b>=5.500)&(b<6.000)) = 5.500;
%         b((b>=6.000)&(b<6.667)) = 6.000;
%         b((b>=6.667)&(b<7.000)) = 6.667;
%         b((b>=7.000)&(b<7.333)) = 7.000;
%         b((b>=7.333)&(b<7.667)) = 7.333;
%         b(b>=7.667) = 7.667;
        
        user_aloc(i,1) = user_aloc(i,1) + sum(b.*mask1); % cada 'i' � uma SNR
        user_aloc(i,2) = user_aloc(i,2) + sum(b.*mask2);
        user_aloc(i,3) = user_aloc(i,3) + sum(b.*mask3);
        
        Total_bits(i) = Total_bits(i) + sum(b);
        %bm(j) = b;
        
        j = j+1;
    end  
    
    user_aloc(i,1) = user_aloc(i,1)/num_itr; % cada 'i' � uma SNR
    user_aloc(i,2) = user_aloc(i,2)/num_itr; 
    user_aloc(i,3) = user_aloc(i,3)/num_itr;
    
    Total_bits(i) = Total_bits(i)/num_itr;
    bits_per_rb(i) = (Total_bits(i)/RB)*RE; 
end

%% Saving Vector in a File
% if (Numerology == 1)
%      Sim.DataSNR = SNR;   
%      Sim.DataBPRB = bits_per_rb;
%      FileName = strcat('C:\Users\alexrosa\Documents\MATLAB\DynamicAllocation\staticAllocation_num1.mat'); 
%      save(FileName,'Sim');  
% else     
%      Sim.DataSNR = SNR;   
%      Sim.DataBPRB = bits_per_rb;
%      FileName = strcat('C:\Users\alexrosa\Documents\MATLAB\DynamicAllocation\staticAllocation_num3.mat'); 
%      save(FileName,'Sim');
% end 

%%
Static.DataSNR = SNR;   
Static.DataBPRB = bits_per_rb;
FileName = strcat('C:\Users\alexrosa\Documents\MATLAB\POC_Resource_Allocation\static.mat'); 
save(FileName,'Static');

%% Gera graficos de Bits/SNR
if (Numerology == 1)
    figure;
    plot(SNR, bits_per_rb, '-.r*');
    title('Aloca��o Est�tica em sistema de multiplo acesso Ortogonal');
    xlabel('SNR [dB]'); 
    ylabel('Bits/RB'); 
    grid on;
    grid minor;
else 
    figure;
    plot(SNR, bits_per_rb, ':rs');
    title('Aloca��o Est�tica em sistema de multiplo acesso Ortogonal');
    xlabel('SNR [dB]'); 
    ylabel('Bits/RB'); 
    grid on;
    grid minor;
end