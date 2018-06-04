classdef WhiteNoise
   %WhiteNoise Class for white noise to transmit through the PA to excite
   %it differently.
   %
   % To Do:
   %  - Translate the OFDM class so that this matches it and can be used
   %  similarly.
   
   properties
      settings
      tools
      desired_rate
      use_random
      pre_pa
      post_pa
   end
   
   methods
      function obj = WhiteNoise(length_in_samples, use_random)
         %WhiteNoise Construct an instance of this class. Will create a WhiteNoise
         %signal in the frequency and time domain. Will also upsample for PA
         %
         % Args:
         %     bandwidth:  Actual BW of signal.
         %     desired_rate: Desired sampling rate in Hz for TX and RX. Will upsample to this.
         %     use_random: boolean. 1 = random signal, 0 = predefined OFDM
         %     signal for repeatability.
         %
         %	Author:	Chance Tarver (2018)
         %		tarver.chance@gmail.com
         
         obj.use_random = use_random;
         obj.settings.length_in_samples = length_in_samples;
         
         obj.pre_pa.frequency_domain_symbols = wgn(length_in_samples,1,0);
      end
   end
end

