function [diagram,diagram_index] = compute_diagram(modulated_psk_with_noise)
%computer ED to generate trellis diagram

conv_length = length(modulated_psk_with_noise);
x=real(modulated_psk_with_noise); 
y=imag(modulated_psk_with_noise);

diagram =zeros(4,4,conv_length);
diagram_index = zeros(4,4,conv_length);

min_A = zeros(1,conv_length);
min_B = zeros(1,conv_length);
min_C=zeros(1,conv_length);
min_D = zeros(1,conv_length);

%compute the ED
for i=1:conv_length
    sub_A=[(x(i)-1)^2+(y(i)-0)^2, (x(i)+1)^2+(y(i)-0)^2];  %(0 4)
    sub_B=[(x(i)-0)^2+(y(i)-1)^2, (x(i)-0)^2+(y(i)+1)^2]; %(2 6)
    sub_C=[(x(i)-(sqrt(2)/2))^2+(y(i)-(sqrt(2)/2))^2, (x(i)+(sqrt(2)/2))^2+(y(i)+(sqrt(2)/2))^2];%(3 7)
    sub_D=[(x(i)+(sqrt(2)/2))^2+(y(i)-(sqrt(2)/2))^2, (x(i)-(sqrt(2)/2))^2+(y(i)+(sqrt(2)/2))^2];%(1 5)
    [min_A(i),index_A]=min(sub_A);
    [min_B(i),index_B]=min(sub_B); 
    [min_C(i),index_C]=min(sub_C); 
    [min_D(i),index_D]=min(sub_D); 

    %save the minimum as the ED
    diagram(1:4,1:4,i) = [min_A(i) min_B(i) Inf Inf;
                           Inf Inf min_C(i) min_D(i);
                           min_B(i) min_A(i) Inf Inf;
                           Inf Inf min_D(i) min_C(i)];

    % save the index to decode unconvolved bit
    diagram_index(1:4,1:4,i) = [index_A index_B Inf Inf;
                           Inf Inf index_C index_D;
                           index_B index_A Inf Inf;
                           Inf Inf index_D index_C];
end

end