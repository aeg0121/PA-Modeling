classdef OFDM < Signal
    %OFDM Class for an LTE-like OFDM signal.
    %
    %	Author:	Chance Tarver (2018)
    %		tarver.chance@gmail.com
    %
    
    properties (Constant, Hidden)
        %	Properties tied to the LTE standard that we may reference to help
        %	construct the signal.
        
        bandwidth_library = [1.4 3 5 10 15 20];
        resource_blocks_library = [6 15 25 50 75 100];
        constellation_library = {'QPSK','16QAM','64QAM'};
        constellaton_order=[4 16 64];
        SUBCARRIERS_PER_RESOURCE_BLOCK = 12;
        SUBCARRIER_SPACING = 15e3;
    end
    
    methods
        function obj = OFDM(params)%bandwidth, desired_rate, number_of_symbols, use_random, modulation)
            %OFDM Construct an instance of this class. Will create an OFDM
            %signal in the frequency and time domain. Will also upsample for PA
            %
            % Args:
            %     bandwidth:  Actual BW of signal. Must be standard for LTE.
            %     modulation: 'QPSK','16QAM', or '64QAM'
            %     desired_rate: Desired sampling rate in Hz for TX and RX. Will upsample to this.
            %     number_of_symbols: int. number of OFDM symbols to create
            %     use_random: boolean. 1 = random signal, 0 = predefined OFDM
            %     signal for repeatability.
            %
            %	Author:	Chance Tarver (2018)
            %		tarver.chance@gmail.com
            %
            
            %Set up some dictionaries
            RB_dictionary = containers.Map(obj.bandwidth_library, ...
                obj.resource_blocks_library);
            
            %Set up properties of class
            obj.settings.bandwidth = params.signal_bw;
            obj.settings.resource_blocks = RB_dictionary(params.signal_bw);
            obj.settings.subcarriers_used = obj.settings.resource_blocks * ...
                obj.SUBCARRIERS_PER_RESOURCE_BLOCK;
            obj.settings.fft_size = 2^ceil(log2(obj.settings.subcarriers_used));
            obj.settings.sampling_rate = obj.SUBCARRIER_SPACING * obj.settings.fft_size;
            obj.settings.symbol_alphabet = obj.QAM_Alphabet(params.constellation);
            obj.settings.use_random = params.use_random_signal;
            obj.settings.number_of_symbols = params.number_of_symbols;
            
            %Set up upsampling and downsampling
            obj.settings.upsample_rate = floor(params.desired_sampling_rate/obj.settings.sampling_rate);
            beta = 0.25;
            obj.settings.upsample_span = 60;
            samples_per_symbol = obj.settings.upsample_rate;
            obj.tools.upsample_rrcFilter = rcosdesign(beta, obj.settings.upsample_span, samples_per_symbol);
            obj.tools.downsample_antialias_filter = firls(100, [0 0.8/obj.settings.upsample_rate ...
                1/obj.settings.upsample_rate 1], [1 1 0 0]);
            
            %Create random symbols on the constellation
            obj.pre_pa.frequency_domain_symbols = zeros(obj.settings.subcarriers_used, params.number_of_symbols);
            if(params.use_random_signal)
                obj.pre_pa.frequency_domain_symbols = obj.settings.symbol_alphabet(ceil(...
                    length(obj.settings.symbol_alphabet) * rand(obj.settings.subcarriers_used, params.number_of_symbols)));
            else
                rng(0); % repeatable random seed
                obj.pre_pa.frequency_domain_symbols = obj.settings.symbol_alphabet(ceil(...
                    length(obj.settings.symbol_alphabet) * rand(obj.settings.subcarriers_used, params.number_of_symbols)));
                rng shuffle; % seed with something else
            end
            obj.pre_pa.frequency_domain_symbols = obj.normalize_symbols(obj.pre_pa.frequency_domain_symbols);
            obj.pre_pa.time_domain = obj.frequency_to_time_domain(obj.pre_pa.frequency_domain_symbols);
        end
        
        
        function out = frequency_to_time_domain(obj, in)
            %frequency_to_time_domain Method that can be used to perform the
            %IDFT to go to the time domain signal for OFDM. It will
            %zero pad according to LTE standards. No CP is used.
            %
            % Args:
            %     in:  vector of subcarriers to perform IDFT on.
            %
            %	Author:	Chance Tarver (2018)
            %		tarver.chance@gmail.com
            %
            
            ifft_input = zeros(obj.settings.fft_size, obj.settings.number_of_symbols);
            ifft_input(2:obj.settings.subcarriers_used/2 + 1, :) = ...
                in(obj.settings.subcarriers_used/2 + 1:end, :);
            ifft_input(end - obj.settings.subcarriers_used/2 + 1 :end, :) = ...
                in(1:obj.settings.subcarriers_used/2, :);
            ifft_output = ifft(ifft_input);
            out = ifft_output(:); % make a single column
        end
        
        
        function out = time_domain_to_frequency(obj, in)
            %time_domain_to_frequency Method that can be used to perform the
            %DFT to go to the frequency domain signal for OFDM. It assumes
            %zero padding according to LTE standards. No CP is used. Only the
            %occupied subcarriers are returned.
            %
            % Args:
            %     in:  time domain vector to perform DFT on.
            %
            %	Author:	Chance Tarver (2018)
            %		tarver.chance@gmail.com
            %
            fft_in = reshape(in,obj.settings.fft_size,obj.settings.number_of_symbols);
            fftout = fft(fft_in);
            
            out = zeros(obj.settings.subcarriers_used, 1);
            out(1:obj.settings.subcarriers_used/2) = fftout(end - obj.settings.subcarriers_used/2 + 1:end);
            out(obj.settings.subcarriers_used/2+1:end) = fftout(2:obj.settings.subcarriers_used/2+1);
        end
        
        
        function alphabet = QAM_Alphabet(obj, ModulationType)
            %QAM_Alphabet Function to create an alphabet of points of the
            %constellation
            
            %Set up some dictionaries
            modulation_dictionary = containers.Map(obj.constellation_library, ...
                obj.constellaton_order);
            
            MQAM = modulation_dictionary(ModulationType);
            
            alphaMqam = -(sqrt(MQAM)-1):2:(sqrt(MQAM)-1);
            A = repmat(alphaMqam,sqrt(MQAM),1);
            B = flipud(A');
            const_qam = A+1j*B;
            const_qam = const_qam(:);
            alphabet = const_qam;
        end
        
        
        function out = normalize_symbols(obj,in)
            out = zeros(obj.settings.subcarriers_used, obj.settings.number_of_symbols);
            for i = 1:obj.settings.number_of_symbols
                % Normalize the symbols so that expected square value of any is 1
                symbols_normalized = sqrt(obj.settings.fft_size) * in(:,i) / (norm(in(:,i)));
                
                % Sanity Check. Calculate expected square value of this vector.
                total = sum(abs(symbols_normalized).^2);
                expected_value = total / obj.settings.fft_size;
                if abs(1 - expected_value) > 0.01
                    error("Not properly normalized");
                end
                out(:,i) = symbols_normalized;
            end
        end
        
        
        function obj = transmit(obj, board, channel, rms_power)
            obj.pre_pa.upsampled_td = obj.up_sample(obj.pre_pa.time_domain);
            [obj.pre_pa.up_td_scaled, obj.pre_pa.scaling_factor] = obj.normalize_for_pa(obj.pre_pa.upsampled_td, rms_power);
            obj.post_pa.up_td_scaled = channel * board.transmit(obj.pre_pa.up_td_scaled);
            obj.post_pa.upsampled_td = obj.post_pa.up_td_scaled/obj.pre_pa.scaling_factor;
            obj.post_pa.time_domain = obj.down_sample(obj.post_pa.upsampled_td);
            obj.post_pa.time_domain  = obj.post_pa.time_domain / ...
                norm(obj.post_pa.time_domain) * norm(obj.pre_pa.time_domain);
            obj.post_pa.frequency_domain_symbols = obj.time_domain_to_frequency(obj.post_pa.time_domain);
        end
    end
end
