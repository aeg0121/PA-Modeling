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


PA_board = 'WARP'; %  either 'WARP' or 'none'
signal_type = 'WGN'; %  either 'OFDM' or 'WGN'
number_of_symbols = 1000;
random_signal = 1;
desired_sampling_rate = 40e6;
signal_bw = 15;

switch PA_board
    case 'WARP'
        board = WARP(1);
        channel = 1+0i;
    case 'none'
        signal = OFDM(signal_bw, 'QPSK', desired_sampling_rate, number_of_symbols, random_signal);
        channel = 1+0i;
        board = PowerAmplifier(0, '', 5, 5);
end

switch signal_type
    case 'OFDM'
        signal = OFDM(signal_bw, desired_sampling_rate, number_of_symbols, random_signal, 'QPSK');
    case 'WGN'
        signal = WhiteNoise(signal_bw, desired_sampling_rate, number_of_symbols, random_signal);
end

% TX
signal = signal.transmit(board, channel);

pa_models = evaluate_pa_models(signal, board.node_tx.serialNumber);

pa_tables = PA_Tables(pa_models);

%% Plots
try
    plot_results('psd', 'PA Input', signal.pre_pa.upsampled_td, signal.settings.sampling_rate * signal.settings.upsample_rate);
    plot_results('psd', 'PA Output', signal.post_pa.upsampled_td, signal.settings.sampling_rate * signal.settings.upsample_rate);
    
    plot_results('am/am', 'Original Signal', signal.pre_pa.upsampled_td, signal.post_pa.upsampled_td);
    plot_results('model', '7th Order, 4 Taps', pa_models(7,4).transmit(signal.pre_pa.upsampled_td), signal.pre_pa.upsampled_td);
    
    plot_results('constellation', 'Original Symbols', signal.pre_pa.frequency_domain_symbols);
    plot_results('constellation', 'Received Symbols', signal.post_pa.frequency_domain_symbols);
end