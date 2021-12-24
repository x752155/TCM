function [trellis_diagram] = compute_diagram_8state(modulated_psk_with_noise)
conv_length = length(modulated_psk_with_noise);
x=real(modulated_psk_with_noise); 
y=imag(modulated_psk_with_noise);

trellis_diagram =zeros(8,8,conv_length);
for i=1:conv_length
    d_0 = (x(i)-1)^2+(y(i)-0)^2;
    d_1 = (x(i)-(sqrt(2)/2))^2+(y(i)-(sqrt(2)/2))^2;
    d_2 = (x(i)-0)^2+(y(i)-1)^2;
    d_3 = (x(i)+(sqrt(2)/2))^2+(y(i)-(sqrt(2)/2))^2;
    d_4 = (x(i)+1)^2+(y(i)-0)^2;
    d_5 = (x(i)-+(sqrt(2)/2))^2+(y(i)+(sqrt(2)/2))^2;
    d_6 = (x(i)-0)^2+(y(i)+10)^2;
    d_7 = (x(i)-(sqrt(2)/2))^2+(y(i)+(sqrt(2)/2))^2;
      trellis_diagram(1:8,1:8,i) = [d_0 d_4 d_2 d_6 Inf Inf Inf Inf;
                           Inf Inf Inf Inf d_1 d_5 d_3 d_7 ;
                           d_4 d_0 d_6 d_2 Inf Inf Inf Inf;
                           Inf Inf Inf Inf d_5 d_1 d_7 d_3;
                           d_2 d_6 d_0 d_4 Inf Inf Inf Inf;
                           Inf Inf Inf Inf d_3 d_7 d_1 d_5 ;
                           d_6 d_2 d_4 d_0 Inf Inf Inf Inf;
                           Inf Inf Inf Inf d_7 d_3 d_5 d_1 ;
                           ];
end


end