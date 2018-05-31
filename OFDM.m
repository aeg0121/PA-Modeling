classdef OFDM
   %OFDM Class for an LTE-like OFDM signal.
   %
   %	Author:	Chance Tarver (2018)
   %		tarver.chance@gmail.com
   %
   
   properties
      settings
      tools
      pre_pa
      post_pa
      optimal
      statistics
   end
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
      function obj = OFDM(bandwidth, modulation, desired_rate)
         %OFDM Construct an instance of this class. Will create an OFDM
         %signal in the frequency and time domain. Will also upsample for PA
         %
         % Args:
         %     bandwidth:  Actual BW of signal. Must be standard for LTE.
         %     modulation: 'QPSK','16QAM', or '64QAM'
         %
         %	Author:	Chance Tarver (2018)
         %		tarver.chance@gmail.com
         %  
         
         %Set up some dictionaries
         RB_dictionary = containers.Map(obj.bandwidth_library, ...
            obj.resource_blocks_library);
         
         %Set up properties of class
         obj.settings.bandwidth = bandwidth;
         obj.settings.resource_blocks = RB_dictionary(bandwidth);
         obj.settings.subcarriers_used = obj.settings.resource_blocks * ...
            obj.SUBCARRIERS_PER_RESOURCE_BLOCK;
         obj.settings.fft_size = 2^ceil(log2(obj.settings.subcarriers_used));
         obj.settings.sampling_rate = obj.SUBCARRIER_SPACING * obj.settings.fft_size;
         obj.settings.symbol_alphabet = obj.QAM_Alphabet(modulation);
         
         %Set up upsampling and downsampling
         obj.settings.upsample_rate = floor(desired_rate/obj.settings.sampling_rate);
         beta = 0.25;
         obj.settings.upsample_span = 60;
         samples_per_symbol = obj.settings.upsample_rate;
         obj.tools.upsample_rrcFilter = rcosdesign(beta, obj.settings.upsample_span, samples_per_symbol);
         obj.tools.downsample_antialias_filter = firls(100, [0 0.8/obj.settings.upsample_rate ...
            1/obj.settings.upsample_rate 1], [1 1 0 0]);
         
         %Create random symbols on the constellation
         obj.pre_pa.frequency_domain_symbols = zeros(obj.settings.subcarriers_used, 1);
         obj.pre_pa.frequency_domain_symbols = obj.settings.symbol_alphabet(ceil(...
            length(obj.settings.symbol_alphabet) * rand(obj.settings.subcarriers_used, 1)));
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
         
         ifft_input = zeros(obj.settings.fft_size,1);
         ifft_input(2:obj.settings.subcarriers_used/2 + 1) = ...
            in(obj.settings.subcarriers_used/2 + 1:end);
         ifft_input(end - obj.settings.subcarriers_used/2 + 1 :end) = ...
            in(1:obj.settings.subcarriers_used/2);
         out = ifft(ifft_input);
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
         fftout = fft(in);
         
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
         % Normalize the symbols so that expected square value of any is 1
         symbols_normalized = sqrt(obj.settings.fft_size) * in / (norm(in));
         
         % Sanity Check. Calculate expected square value of this vector.
         total = sum(abs(symbols_normalized).^2);
         expected_value = total / obj.settings.fft_size;
         if abs(1 - expected_value) > 0.01
            error("Not properly normalized");
         end
         out = symbols_normalized;
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
         out = out(1:512);
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
