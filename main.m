clear; clc; close all;

%% TODO:
% - Add other PA types
% - Make a whitenoise class
% - MIMO
% - Add statistics.
%     + SNR
%     + ACLR
% - Crest Factor Reduction
% FIR Filter for subsample delay estimation/correction. 


%% Set up the experiment


PA_board = 'none'; %  either 'WARP' or 'none'
number_of_symbols = 10;
random_signal = 1; 
desired_sampling_rate = 40e6;
signal_bw = 5;


switch PA_board
   case 'WARP'
      signal = OFDM(signal_bw, 'QPSK', desired_sampling_rate, number_of_symbols, random_signal);
      board = WARP(1);
      channel = 1+0i;    
   case 'none'
      signal = OFDM(signal_bw, '16QAM', desired_sampling_rate, number_of_symbols, random_signal);
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

[pa_models, pa_tabels] = evaluate_pa_models(signal,board.node_tx.serialNumber);

%% Plots
plot_results('psd', 'PA Input', signal.pre_pa.upsampled_td, signal.settings.sampling_rate * signal.settings.upsample_rate);
plot_results('psd', 'PA Output', signal.post_pa.upsampled_td, signal.settings.sampling_rate * signal.settings.upsample_rate);

plot_results('constellation', 'Original Symbols', signal.pre_pa.frequency_domain_symbols);
plot_results('constellation', 'Received Symbols', signal.post_pa.fd_symbols);

plot_results('am/am', 'Original Signal', signal.pre_pa.upsampled_td, signal.post_pa.upsampled_td);
plot_results('model', '9th Order, 2 Taps', pa_models(9,2).transmit(signal.pre_pa.upsampled_td), signal.pre_pa.upsampled_td);
