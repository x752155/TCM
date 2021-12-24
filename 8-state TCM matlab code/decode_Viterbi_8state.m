function [decoded_bits] = decode_Viterbi_8state(trellis_diagram)
tmp_bits_length = 2*length(trellis_diagram);
conv_length = length(trellis_diagram);
tmp_decoded_bits= zeros(1,tmp_bits_length);

chosen_path = zeros(8,2,conv_length);
weighted_path = zeros(8,conv_length);

quick_map=[
    [1,2,3,4,inf,inf,inf,inf];
    [inf,inf,inf,inf,5,6,7,8];
    [1,2,3,4,inf,inf,inf,inf];
    [inf,inf,inf,inf,5,6,7,8];
    [1,2,3,4,inf,inf,inf,inf];
    [inf,inf,inf,inf,5,6,7,8];
    [1,2,3,4,inf,inf,inf,inf];
    [inf,inf,inf,inf,5,6,7,8];
];

quick_decode_bits_map=zeros(8,8);
for i =1:8
    if mod(i,2)~=0
        quick_decode_bits_map(i,:) = [1,2,3,4,inf,inf,inf,inf];
    else
        quick_decode_bits_map(i,:) = [inf,inf,inf,inf,1,2,3,4];
    end
end
quick_decode_bits_map2 = [0,1,0,1];
weighted_path(1,1) = trellis_diagram(1,1,1);
weighted_path(2,1) = trellis_diagram(1,2,1);
weighted_path(3,1) = trellis_diagram(1,3,1);
weighted_path(4,1) = trellis_diagram(1,4,1);
chosen_path(1,:,1) = [1,1];
chosen_path(2,:,1) = [1,2];
chosen_path(3,:,1) = [1,3];
chosen_path(4,:,1) = [1,4];

for k = 2:conv_length
    tmp_diagram = trellis_diagram(:,:,k);
    trans_path_weight = inf(8,8);
    for start_state_index = 1:8
        if k==2 && start_state_index>4
            continue;
        end
        next_state = quick_map(start_state_index,:);
        for end_state_index = 1:length(next_state)
            end_state = next_state(end_state_index);
            if end_state==inf  %if the ED is inf, next state is unreachable
                 continue
             end       
            start_state = start_state_index;
            path = trellis_diagram(start_state,end_state,k)+ weighted_path(start_state,k-1);
            trans_path_weight(end_state,start_state) = path;
        end
    end
     for t =1:8
        [min_path, min_path_index] = min(trans_path_weight(t,:));
        weighted_path(t,k) = min_path;
        chosen_path(t,:,k)=[min_path_index,t];
    end

end


last= weighted_path(:,conv_length);
[total_min_path, total_min_path_index] = min(last);
tmp = total_min_path_index;
path_list = zeros(1,conv_length+1);
path_list(conv_length+1) = tmp;
% build the final path
first_bit_list=zeros(1,conv_length);
for ii = 1:conv_length
    i = conv_length+1-ii;
    previous = chosen_path(tmp,1,i);
    path_list(i) = previous;
    tmp = previous;
end

decoded_state_list = zeros(1,conv_length+1);
decoded_bits =zeros(1,conv_length+1);
for i = 2:conv_length-2
     tmp_sign =quick_decode_bits_map(path_list(i),path_list(i+1));
    decoded_bits(i) = quick_decode_bits_map2(tmp_sign);
end

end