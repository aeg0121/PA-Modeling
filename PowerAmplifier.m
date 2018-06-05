classdef PowerAmplifier
   %PowerAmplifier Construct a PA and broadcast.
   
   properties
      PolyCoeffs
      create_model
      order
      memory_depth
      mse_of_fit
      sparsity_factor
      node_tx
   end
   properties (Constant)
      WienerFilter_B = [1;0.2];
      WienerFilter_A = [1;-0.1];
   end
   
   methods
      function obj = PowerAmplifier(create_model, signal, order, memory_depth)
         %POWERAMPLIFIER Construct an instance of this class
         %
         % Args:
         %     create_model: 1 or 0. Tells it to use lms learning on input/output relationship of signal.
         %     order:   int with PA order. Should be odd. 1, 3, 5, etc.
         %     memory_depth: int with number of taps in FIR filter
         
         if nargin == 0
            return; 
         end
         
         obj.create_model = create_model;
         obj.order = order;
         obj.memory_depth = memory_depth;
         obj.sparsity_factor = 1;
         obj.node_tx.serialNumber = 9999;  %Serial number to avoid error when running code with no board.
         
         if obj.create_model
            obj = obj.perform_lms_learning(signal);
         else
            % Wiener Power Amplifier Model
            PolyOrder   = 5;        % PA polynomial order
            G_PA        = 25;       % PA gain in dB
            IIP3        = 17;       % PA IIP3 in dBm
            P_1dBOut_dB = 26.5;     % PA output 1-dB compression point in dBm
            obj.PolyCoeffs = obj.PA_poly_parameters(G_PA, IIP3, P_1dBOut_dB, PolyOrder);
         end
      end
      
      function obj = perform_lms_learning(obj, signal)
         %perform_lms_learning	Learn a PA model
         %	obj.perform_lms_learning(signal) finds the best LS fit for a PH
         %	power amplifier. The signal is expected to be a class with post
         %	and pre PA data.
         %
         %  The LS regression solution is standard. Can be derrived by
         %  doing the sum_i [y_i - (beta_0 x_i + beta_! x_i)^2]
         %  optimization. The PA model is linear with respect to the
         %  coefficients. 
         %
         %	Author:	Chance Tarver (2018)
         %		tarver.chance@gmail.com
         %
         
         
         % Construct signal matrix with basis vectors for each nonlinearity
         x = signal.pre_pa.upsampled_td;
         y = signal.post_pa.upsampled_td;
         
         number_of_basis_vectors = obj.memory_depth * (obj.order + 1)/2;
         X = zeros(length(signal.pre_pa.upsampled_td), number_of_basis_vectors);
         
         count = 1;
         for i = 1:2:obj.order
            branch = x .* abs(x).^(i-1);
            for j = 1:obj.memory_depth
               delayed_version = zeros(size(branch));
               delayed_version(j*obj.sparsity_factor:end) = branch(1:end - j*obj.sparsity_factor + 1);
               X(:, count) = delayed_version;
               count = count + 1;
            end
         end
         
         obj.PolyCoeffs = ((X'*X)+1e-13*eye(size((X'*X)))) \ (X'*y) ;
         
         model_pa_output = obj.transmit(x);
         
         obj.mse_of_fit = norm(y - model_pa_output);
      end
      
      function pa_output = transmit(obj, in)
         %transmit	Broadcast the input data using the PA model stored in
         %the object
         %
         %	obj.transmit(in) send in through the PH model that is stored in
         %	the object. It expands the input into a matrix where the columns
         %  are the different nonlinear branches or delayed versions of the
         %  nonlinear branches to model the FIR filter. A product can
         %  be done with the coefficient to get the PA output.
         %	 
         %
         %	Author:	Chance Tarver (2018)
         %		tarver.chance@gmail.com
         %         
         if obj.create_model
            number_of_basis_vectors = obj.memory_depth * (obj.order + 1)/2;
            X = zeros(length(in), number_of_basis_vectors);
            
            count = 1;
            for i = 1:2:obj.order
               branch = in .* abs(in).^(i-1);
               for j = 1:obj.memory_depth
                  delayed_version = zeros(size(branch));
                  delayed_version(j * obj.sparsity_factor:end) = branch(1:end - j*obj.sparsity_factor + 1);
                  X(:, count) = delayed_version;
                  count = count + 1;
               end
            end         
            
            pa_output = X * obj.PolyCoeffs;
            
         else
            %wiener_transmit Transmit over a Weiner PA model
            %Scale to unit input.
            larger_signal = 0.41  * in /mean(abs(in)); % This scaling was choosen to make the AM/AM curve look nice with a little bit of saturation at the top.
            PAinFiltered = filter(obj.WienerFilter_B, obj.WienerFilter_A, larger_signal);
            
            PolyOrder = 2*length(obj.PolyCoeffs) - 1;
            
            FilteredBasisFunctions = zeros(length(PAinFiltered),(PolyOrder+1)/2);
            for k=1:2:PolyOrder
               FilteredBasisFunctions(:,(k+1)/2) = PAinFiltered.*abs(PAinFiltered).^(k-1);
            end
            unnormalized_output = FilteredBasisFunctions * obj.PolyCoeffs;
            pa_output = unnormalized_output*norm(in)/norm(unnormalized_output);
         end
      end
      function [param] = PA_poly_parameters(obj, G_dB, IIP3_dB, P_1dBOut_dB, PolyOrder)
         % PA polynomial parameter calculation based on PA gain, IIP3, and 1-dB compression point
         
         % G_dB = 0; % PA gain in dB; compare with alfa1 below
         % IIP3 = 15; % [dBm]
         iip3 = 10^(IIP3_dB/10);
         % P_1dBOut_dB = 20;  % PA output 1-dB compression point; [dB]
         P_1dBOut = (10^(P_1dBOut_dB/10));
         P_1dBIn = (10^((P_1dBOut_dB-G_dB+1)/10));
         % P_1dBIn_dB = 10*log10(P_1dBIn);
         
         alfa1 = 10^(G_dB/20);
         alfa3 = -alfa1/iip3*exp(1i*0.2986);
         alfa5 = (sqrt(P_1dBOut)-alfa1*sqrt(P_1dBIn)-alfa3*sqrt(P_1dBIn)^3)/(sqrt(P_1dBIn)^5);
         
         if PolyOrder == 5
            param = [alfa1;alfa3;alfa5];
         else
            param = [alfa1;alfa3];
         end
      end
      function out = up_sample(obj, in)
         %up_sample	Wrapper to upsample and filter for PA transmission.
         %	 
         %
         %	Author:	Chance Tarver (2018)
         %		tarver.chance@gmail.com
         %  
         rrcFilter = rcosdesign(0.25, 60, obj.upsample_rate);
         out = upfirdn(in, rrcFilter, obj.upsample_rate);
      end
      function out = down_sample(obj, in)
         %down_sample	Wrapper to downsample and antialias filter. Also
         %corrects for the filter timing.
         %	 
         %
         %	Author:	Chance Tarver (2018)
         %		tarver.chance@gmail.com
         %  
         
         % Anti alias filter
         b = firls(100, [0 0.8/obj.upsample_rate 1/obj.upsample_rate 1], [1 1 0 0]);
         filtered_signal = filter(b, 1, in);
         
         compensate_for_filter_timing = filtered_signal(51:end);
         compensate_for_upsampling_rrc = compensate_for_filter_timing(301:end);
         
         % Downsampling
         out = downsample(compensate_for_upsampling_rrc, obj.upsample_rate);
         out = out(1:512);
      end
   end
end
