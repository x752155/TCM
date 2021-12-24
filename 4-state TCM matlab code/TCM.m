clc
clear all
close all
% global 
bits_length =300000;
bits = randi([0,1],1,bits_length); %bits to be sent


conv_inut = bits(1:2:end);
uncode_input = bits(2:2:end);
conv_output = conv_encode(conv_inut);


conv_length = bits_length/2;
psk_unmodulated = zeros(1,conv_length);
for i = 1:(conv_length)
    psk_unmodulated(i) = 2*conv_output(2*i-1)+conv_output(2*i)+4*uncode_input(i);
end    

[modulated_psk] = modulate_psk(psk_unmodulated);


SNR =5:1:14;

qpsk=[];
BER=[];
EER=[];

for snr_index = 1:length(SNR)
SNR(snr_index)
snr_v = 10^(SNR(snr_index)/10);
sigma2=1/snr_v;

Noise=sqrt(sigma2/2)*(randn(1,conv_length)+j*randn(1,conv_length));
modulated_psk_with_noise = modulated_psk +Noise;


%generate the trellis diagram
[trellis_diagram,uncoded_index] = compute_diagram(modulated_psk_with_noise);


[decoded_bits,decoded_symbols] =decode_Viterbi(trellis_diagram,uncoded_index);


% compute BER
BER = [BER sum(bits~=decoded_bits)/length(decoded_bits)];


% compute error-event
error_event_count=0;
for i =2:conv_length
    if (decoded_bits(i) == bits(i)) && (decoded_bits(i-1)~=bits(i-1))
        error_event_count=error_event_count+1;
    end
end
EER=[EER error_event_count/bits_length];

% compute 
QPSK_ser = erfc(sqrt(0.5*(snr_v))) - (1/4)*(erfc(sqrt(0.5*(snr_v)))).^2;
qpsk=[qpsk QPSK_ser];

end

figure(1)

semilogy(SNR,BER,'r');hold on;
semilogy(SNR,qpsk,'b');hold on;
semilogy(SNR,EER,'m');hold on;

grid on;
xlabel('SNR'); 
ylabel('BER and EER');
title('8-psk TCM'); 
legend('BER','QPSK','Error-event probability')
%axis([0 18 10e-5 1])
                           
