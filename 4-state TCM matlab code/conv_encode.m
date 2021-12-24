function [conv_output] = conv_encode(conv_input)

mem = zeros(1,2);

for ii=1:length(conv_input)   
    inner_val = [conv_input(ii) mem];
    second_out(ii) = inner_val(2);
    first_out(ii) = mod(inner_val(1)+inner_val(3),2);
    mem = inner_val(1:end-1);
    out_val = [first_out(ii) second_out(ii)];
    conv_output(ii*2-1:ii*2)=out_val;
end
conv_output = [conv_output];
end