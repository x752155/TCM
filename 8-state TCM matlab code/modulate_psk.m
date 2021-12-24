function [modulated_psk] = modulate_psk(psk_unmodulated)
conv_length = length(psk_unmodulated);

% E(|a|^2) = 1
mapping1 = [1,sqrt(2)/2,0,-sqrt(2)/2,-1,-sqrt(2)/2,0,sqrt(2)/2];
mapping2 = [0,sqrt(2)/2,1,sqrt(2)/2,0,-sqrt(2)/2,-1,-sqrt(2)/2];
modulated_psk = zeros(1,conv_length);
for ii = 1:conv_length
    modulated_psk(ii) = mapping1(psk_unmodulated(ii)+1)+i*mapping2(psk_unmodulated(ii)+1);
end
end