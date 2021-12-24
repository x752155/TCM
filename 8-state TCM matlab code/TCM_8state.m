clc
clear all
close all
% global 
bits_length =400000;
bits = randi([0,1],1,bits_length+1); 
%generate bits
% first bit and last two bits are set to 0
bits(1) = 0;
bits(bits_length+1) = 0;
bits(bits_length+2) = 0;
bits_length = bits_length+2;
conv_output = conv_encode_8state(bits);


conv_length = bits_length-1;
psk_unmodulated = zeros(1,conv_length);
for i = 1:(conv_length)
    psk_unmodulated(i) = 4*conv_output(3*i-2)+2*conv_output(3*i-1)+conv_output(3*i);
end    

[modulated_psk] = modulate_psk(psk_unmodulated);


SNR =5:1:14;

qpsk=[];
BER=[];
EER=[];

for bit_error_num = 1:length(SNR)
SNR(bit_error_num)
snr_v = 10^(SNR(bit_error_num)/10);
sigma2=1/snr_v;

Noise=sqrt(sigma2/2)*(randn(1,conv_length)+j*randn(1,conv_length));
modulated_psk_with_noise = modulated_psk +Noise;


%generate the trellis diagram
[trellis_diagram] = compute_diagram_8state(modulated_psk_with_noise);




[decoded_bits] =decode_Viterbi_8state(trellis_diagram);


% compute BER
BER = [BER sum(bits~=decoded_bits)/length(decoded_bits)];



error_event_count=0;

for i =2:conv_length
    if (decoded_bits(i) == bits(i)) && (decoded_bits(i-1)~=bits(i-1))
        error_event_count=error_event_count+1;
    end
end
EER=[EER error_event_count/bits_length];
QPSK_ser = erfc(sqrt(0.5*(snr_v))) - (1/4)*(erfc(sqrt(0.5*(snr_v)))).^2;
qpsk=[qpsk QPSK_ser];

end

figure(1)

semilogy(SNR,BER,'r');hold on;

semilogy(SNR,qpsk,'b');hold on;
semilogy(SNR,EER,'m');hold on;
grid on;
xlabel('SNR (dB)'); ylabel('BER and EER');
title('8-state TCM'); 
legend('BER','QPSK','EER')
    
