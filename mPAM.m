
clear
clc

% M-PAM
m_arr = [2,4,8,16,32,64];

%SNR
snr_dB=[-15:0.5:50];

%capacity for differenet SNR and M
c_plot = zeros(length(m_arr),length(snr_dB));

%iterations per M
iters=10; 

%symbols per iteration
sym_num=1000;


% for each M
for m_index = 1:length(m_arr)
    m = m_arr(m_index);
    m

    %assume E{|a|^2} =1
    d = sqrt(12/(m^2-1)); 
    constell = (1:m)*d;

    %generate constellation diagram
    constell = constell - mean(constell);

    %uniform distribution
    prop_constell=ones(1,length(constell)) * 1/ length(constell);
    power=sum(prop_constell.*constell.^2);  % =1
    for snr_index=1:length(snr_dB)
       
        snr=10^(snr_dB(snr_index)/10); 

        %sigma of N
        sigma2=power/snr;  
        sigma=sqrt(sigma2);
        c_temp=zeros(1,iters);
    

        for index_iters=1:iters
            %a before modualtion
            x=rand(1,sym_num);           
            pconstell=cumsum(prop_constell);
            a=zeros(1,sym_num);  
            a(x<=pconstell(1))=constell(1);  
    
            %  Modulation 
            for index_constell=2:length(constell)
                a(x>pconstell(index_constell-1)&x<=pconstell(index_constell))=constell(index_constell);
    
            end
            
            % Noise (0,sigma2)
            Noise=sigma*randn(1,sym_num); 

            % z
            z = a+Noise;

%             equation 5, the plot result is the same but slower while simulation
%             sum1=0;
%             for k =1:m
%                sum2=0;
%                for i = 1:m
%                    exp1 = exp(-(Noise).^2/(2*sigma2));
%                    inner = (Noise+constell(k)-constell(i));
%                    exp2 =exp((-(inner).^2)/(2*sigma2));
%                    sum2 = sum2+(exp2./exp1);
%                end
%                sum1 = sum1+ mean(log2(sum2));
%             end      
%             c_temp(index_iters)=log2(m) -(sum1/m);    
        

            %also equation 5 but much faster while simulation
            sum_tmp=0;
            for i = 1:m
                p1=exp(-(Noise).^2/(2*sigma2));
                p2 =exp(-(z-constell(i)).^2/(2*sigma2));
               sum_tmp = sum_tmp+ p2./p1;
            end
            c_temp(index_iters)=log2(m)-mean(log2(sum_tmp));
         
        end
   
        c(snr_index)=mean(c_temp);
    
    end
    %save the result
    c_plot(m_index,:) = c(:);

end

%ideal capacity
SNR = zeros(1,length(snr_dB));
targetC =zeros(1,length(snr_dB));

new_snr_dB=[-15:0.01:50];
for i =1:length(new_snr_dB)
    SNR(i) = 10^(new_snr_dB(i)/10);
    targetC(i) = 0.5*log2(1+SNR(i));
end

for i = 1:length(m_arr)
    plot(snr_dB,c_plot(i,:));
    hold on;
end
plot(new_snr_dB,targetC,'r');
grid on
legend(['Uniform ' num2str(m) '-constell']);
temp = c_plot(6,:);
xlabel('Signal to noise ratio [dB]');
ylabel('Capacity [b/dim]');
legend('2-PAM','4-PAM','8-PAM','16-PAM','32-PAM','64-PAM','1/2log2(1+SNR)')