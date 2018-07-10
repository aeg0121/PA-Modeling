classdef WhiteNoise < Signal
    %WhiteNoise Class for white noise to transmit through the PA to excite
    %it differently.
    %
    
    methods
        function obj = WhiteNoise(params) %signal_bw, desired_sampling_rate, length_in_samples, use_random)
            %WhiteNoise Construct an instance of this class. Will create a WhiteNoise
            %signal in the frequency and time domain. Will also upsample for PA
            %
            % Args:
            %     bandwidth:  Actual BW of signal.
            %     desired_rate: Desired sampling rate in Hz for TX and RX. Will upsample to this.
            %
            %	Author:	Chance Tarver (2018)
            %		tarver.chance@gmail.com
            
            obj.settings.use_random = params.use_random_signal;
            obj.settings.number_of_symbols = params.number_of_samples;
            
            obj.settings.sampling_rate = params.signal_bw*1e6;
            
            %Set up upsampling and downsampling
            obj.settings.upsample_rate = floor(params.desired_sampling_rate/(obj.settings.sampling_rate));
            beta = 0.25;
            obj.settings.upsample_span = 60;
            samples_per_symbol = obj.settings.upsample_rate;
            obj.tools.upsample_rrcFilter = rcosdesign(beta, obj.settings.upsample_span, samples_per_symbol);
            obj.tools.downsample_antialias_filter = firls(100, [0 0.8/obj.settings.upsample_rate ...
                1/obj.settings.upsample_rate 1], [1 1 0 0]);
            
            obj.settings.fft_size = 1; % For compatiability with Signal class
            
            % Make the signal
            obj.pre_pa.time_domain = wgn(params.number_of_samples, 1, 0) + 1i *  wgn(params.number_of_samples, 1, 0);
            
        end
        
        
        function obj = transmit(obj, board, channel, rms_power)
            obj.pre_pa.upsampled_td = obj.up_sample(obj.pre_pa.time_domain);
            [obj.pre_pa.up_td_scaled, obj.pre_pa.scaling_factor] = obj.normalize_for_pa(obj.pre_pa.upsampled_td, rms_power);
            obj.post_pa.up_td_scaled = channel * board.transmit(obj.pre_pa.up_td_scaled);
            obj.post_pa.upsampled_td = obj.post_pa.up_td_scaled/obj.pre_pa.scaling_factor;
            obj.post_pa.time_domain = obj.down_sample(obj.post_pa.upsampled_td);
            obj.post_pa.time_domain  = obj.post_pa.time_domain / ...
                norm(obj.post_pa.time_domain) * norm(obj.pre_pa.time_domain);
        end
    end
end