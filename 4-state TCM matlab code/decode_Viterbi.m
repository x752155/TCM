function [decoded_bits,decoded_symbols] = decode_Viterbi(trellis_diagram,diagram_index)
conv_length = length(trellis_diagram);
bits_length= conv_length*2;
decoded_bits= zeros(1,bits_length);
decoded_symbols = zeros(1,conv_length);


chosen_path = zeros(4,2,conv_length);

%initialization of weighted path of the first two bits
weighted_path = zeros(4,conv_length);
weighted_path(1,1) = trellis_diagram(1,1,1);
weighted_path(2,1) = trellis_diagram(1,2,1);
chosen_path(1,:,1) = [1,1];
chosen_path(2,:,1) = [1,2];

weighted_path(1,2) = trellis_diagram(1,1,2) + weighted_path(1,1);
weighted_path(2,2) = trellis_diagram(1,2,2) + weighted_path(1,1);
weighted_path(3,2) = trellis_diagram(2,3,2) + weighted_path(2,1);
weighted_path(4,2) = trellis_diagram(2,4,2) + weighted_path(2,1);
chosen_path(1,:,2) = [1,1];
chosen_path(2,:,2) = [1,2];
chosen_path(3,:,2) = [2,3];
chosen_path(4,:,2) = [2,4];
% start at 00


symbol_map=[
    [0,2,inf,inf];
    [inf,inf,1,3];
    [2,0,inf,inf];
    [inf,inf,3,1];
];
quick_map = [
    [1,2,inf,inf];
    [inf,inf,3,4];
    [1,2,inf,inf];
    [inf,inf,3,4]
    ];

quick_decode_bits_map = [
    [0,1,inf,inf];
    [inf,inf,0,1];
    [0,1,inf,inf];
    [inf,inf,0,1];    
    ];

% iteration
for k=2:conv_length-1
    trans_path_weight = inf(4,4); % save total 8 path weight(ED)
    for start_state_index=1:4
        next_state= quick_map(start_state_index,:); % posible next state;

        for end_state_index=1:length(next_state)
             end_state = next_state(end_state_index);
             if end_state==inf  %if the ED is inf, next state is unreachable
                 continue
             end       
            start_state = start_state_index;
           
            %start_state -->e nd_state
            path = trellis_diagram(start_state,end_state,k+1)+ weighted_path(start_state,k);
            
            %save the ED of the path to chose the minimum
            trans_path_weight(end_state,start_state) = path;
        end
    end

    % chose the best path to the next state
    for t =1:4
        [min_path, min_path_index] = min(trans_path_weight(t,:));
        weighted_path(t,k+1) = min_path;
        chosen_path(t,:,k+1)=[min_path_index,t];
    end

end %k

% from the last state trace back the path
last = weighted_path(:,conv_length);
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
    % decode first bit through the ED diagram index
    first_bit_list(i)= diagram_index(previous,tmp,i); 
    tmp = previous;

    
end


% decode bits and the symbol(0-7)
for i = 1:conv_length    
    decoded_bits(2*i-1) = quick_decode_bits_map(path_list(i),path_list(i+1));
    decoded_bits(2*i) = first_bit_list(i)-1;
    decoded_symbols(i) = symbol_map(path_list(i),path_list(i+1))+4*(first_bit_list(i)-1);
end





end