clear; clc; close all;

%% TODO:
% - Add other PA types
% - MIMO
% - Multiple Symbols
% - Add statistics.
%     + SNR
%     + ACLR
% - Crest Factor Reduction
% FIR Filter for subsample delay estimation/correction. 


% DONE:
% - Create forward PA model of WARP before optimization
% - Fix hardcoding in the downsampling
% - Add WARP as a PA option
% - Add memory effects into model
% - Add webRF option
% - Metric for Evaluating PA models' fit. MSE or something
% - Sparsity option for FIR filter tap in model
% - Add statistics.
%     + PAPR
%     + EVM

%% Set up the experiment

PA_board = 'WARP'; %  either 'webRF' or 'WARP'
% rng(0);
switch PA_board
   case 'WARP'
      signal = OFDM(5, 'QPSK', 40e6);
      board = WARP(1);
      channel = 1+0i;
% rng('default');      
   case 'none'
      % webRF needs 200 MHz sampling rate. Also needs even number of
      % samples
      signal = OFDM(5, '16QAM', 200e6);
      channel = 1+0i;
      board = PowerAmplifier(0, '', 5, 5);  
end

% TX
signal.pre_pa.upsampled_td = signal.up_sample(signal.pre_pa.time_domain);
signal.post_pa.upsampled_td = channel * board.transmit(signal.pre_pa.upsampled_td);
signal.post_pa.time_domain = signal.down_sample(signal.post_pa.upsampled_td);
signal.post_pa.time_domain  = signal.post_pa.time_domain / ...
   norm(signal.post_pa.time_domain) * norm(signal.pre_pa.time_domain);
signal.post_pa.fd_symbols = signal.time_domain_to_frequency(signal.post_pa.time_domain);

[pa_model_11,table_11,pa_model_12,table_12,pa_model_13,table_13,pa_model_14,table_14,...
 pa_model_31,table_31,pa_model_32,table_32,pa_model_33,table_33,pa_model_34,table_34,...   
 pa_model_51,table_51,pa_model_52,table_52,pa_model_53,table_53,pa_model_54,table_54,...
 pa_model_71,table_71,pa_model_72,table_72,pa_model_73,table_73,pa_model_74,table_74,...
 pa_model_91,table_91,pa_model_92,table_92,pa_model_93,table_93,pa_model_94,table_94] = evaluate_pa_models(signal,board.node_tx.serialNumber);

%% Plots
% plot_results('psd', 'PA Input', signal.pre_pa.upsampled_td, signal.settings.sampling_rate * signal.settings.upsample_rate);
% plot_results('psd', 'PA Output', signal.post_pa.upsampled_td, signal.settings.sampling_rate * signal.settings.upsample_rate);
% 
% %plot_results('symbols', 'Original Symbols', signal.pre_pa.frequency_domain_symbols);
% %plot_results('symbols', 'Received Symbols', signal.post_pa.fd_symbols);
% 
% plot_results('constellation', 'Original Symbols', signal.pre_pa.frequency_domain_symbols);
% plot_results('constellation', 'Received Symbols', signal.post_pa.fd_symbols);
% 
% plot_results('am/am', 'Original Signal', signal.pre_pa.upsampled_td, signal.post_pa.upsampled_td);
% plot_results('model', '9th Order, 2 Taps', pa_model.transmit(signal.pre_pa.upsampled_td), signal.pre_pa.upsampled_td);
% %plot_results('model', '7th Order, 3 Taps', pa_model_52.transmit(signal.pre_pa.upsampled_td), signal.pre_pa.upsampled_td);
% %plot_results('model', '7th Order, 5 Taps', pa_model_71.transmit(signal.pre_pa.upsampled_td), signal.pre_pa.upsampled_td);
% %plot_results('pa_out', ['Actual PA Output' 'Real PA Output'], lms.beta, signal.post_pa.upsampled_td);
