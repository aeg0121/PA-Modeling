classdef Signal
    %SIGNAL Superclass for signals. There is a subclass for more specific
    %types of signals like OFDM of whitenoise.
    
    properties
        settings
        tools
        pre_pa
        post_pa
        optimal
        statistics
        use_random
    end
    
    methods
        function obj = Signal()
            %Signal Construct an instance of this class
            %   Detailed explanation goes here
            
        end
        
        function obj = calculate_PAPR(obj)
            
            % EVM
            error_vector = obj.post_pa.fd_symbols - obj.pre_pa.frequency_domain_symbols;
            max_reference = max(abs(obj.pre_pa.frequency_domain_symbols));
            %Maybe need average power reference instead
            % https://ieeexplore.ieee.org/stamp/stamp.jsp?arnumber=4176888
            obj.statistics.evm = 100 * norm(error_vector) / norm(obj.pre_pa.frequency_domain_symbols);
            
            x = obj.pre_pa.time_domain;
            % PAPR
            peak = max(abs(x))^2;
            avg = rms(x)^2;
            ratio = peak/avg;
            obj.statistics.PAPR = 10*log10(ratio);
            
            
            % CCDF Plot
            papr = 0:.25:14; % dB vector of PAPR values
            P = abs(x).^2; % W power of each sample
            Pratio = P/mean(P); % power/average power
            PdB = 10*log10(Pratio);
            for i = 1:length(papr)
                y(i) = length(find(PdB >= papr(i)))/length(x); % # of samples exceeding papr(i)
            end
            figure(20)
            semilogy(papr,y),grid
            xlabel('dB above average power'),ylabel('probability')
            title('CCDF'),axis([0 14 1e-5 1])
        end
        
    end
end
