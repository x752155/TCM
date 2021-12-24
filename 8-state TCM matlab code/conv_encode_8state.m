function [conv_output] = conv_encode_8state(conv_input)


mem = zeros(1,3);

for ii=1:length(conv_input)-1
    inter_var = [conv_input(ii) conv_input(ii+1) mem];
    third_out(ii) = inter_var(4);
    second_out(ii) = mod(conv_input(ii+1) + mem(1),2);
    
    first_out(ii) = mod(conv_input(ii)+mem(3),2);
    mem = [mem(2) conv_input(ii) conv_input(ii+1)];
    out_val = [first_out(ii) second_out(ii) third_out(ii)];
    conv_output(ii*3-2:ii*3)=out_val;


end
conv_output = [conv_output];
end