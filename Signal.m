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
        
        
        function out = up_sample(obj, in)
            out = upfirdn(in, obj.tools.upsample_rrcFilter, obj.settings.upsample_rate);
        end
        
        
        function out = down_sample(obj, in)
            
            % Anti alias filter
            filtered_signal = filter(obj.tools.downsample_antialias_filter, 1, in);
            
            compensate_for_filter_timing = filtered_signal(51:end); % Assume length 100 antialias filter
            
            delay = obj.settings.upsample_rate * obj.settings.upsample_span / 2;
            compensate_for_upsampling_rrc = compensate_for_filter_timing(delay + 1:end);
            
            % Downsampling
            out = downsample(compensate_for_upsampling_rrc, obj.settings.upsample_rate);
            out = out(1:obj.settings.fft_size*obj.settings.number_of_symbols);
        end
        
        
        function obj = calculate_PAPR(obj)
            % EVM
            try
                error_vector = obj.post_pa.frequency_domain_symbols - obj.pre_pa.frequency_domain_symbols;
                obj.statistics.evm = 100 * norm(error_vector) / norm(obj.pre_pa.frequency_domain_symbols);
            end
            %max_reference = max(abs(obj.pre_pa.frequency_domain_symbols));
            %Maybe need average power reference instead
            % https://ieeexplore.ieee.org/stamp/stamp.jsp?arnumber=4176888
        
            
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
            
            plot_results('ccdf', obj.settings.label, papr, y);
        end
        
        
        function [out, scale_factor] = normalize_for_pa(obj, in, RMS_power)
            scale_factor = RMS_power/rms(in);
            out = in * scale_factor;
            if abs(rms(out) - RMS_power) > 0.01
                error('RMS is wrong.');
            end
            
            max_real = max(abs(real(out)));
            max_imag = max(abs(imag(out)));
            max_max = max(max_real, max_imag);
            fprintf('Maximum value: %1.2f\n', max_max);
        end
    end
end

