clear; clc; close all;

%% TODO:
% - Add other PA types
% - MIMO
% - Add statistics.
%     + SNR
%     + ACLR
% - Crest Factor Reduction
% - Investigate the sensitivity of the coeffs
% - Why do coeffs have 180deg variability?


%% Set up the experiment
params.PA_board = 'WARP';      % either 'WARP', 'webRF', or 'none'
params.RF_port  = 'A2B';       % Broadcast from RF A to RF B. Can also do 'B2A'
params.signal_type = 'OFDM';    % either 'OFDM' or 'WGN' or 'CA'
params.use_random_signal = 1;  % 1 forces a new OFDM each time. 0 will use the same random OFDM signal
params.signal_bw = 5;          % Bandwidth of the OFDM of WGN signal
params.channel = 1+0i;
params.RMS_power = 0.25;

%Only used in OFDM
params.constellation = 'QPSK'; % Only used in OFDM
params.number_of_symbols = 30;

% Only used in WGN
params.number_of_samples = 10000;

[board, signal] =  setup(params);

% TX
signal = signal.transmit(board, params.channel, params.RMS_power);

pa_models = evaluate_pa_models(signal, board.node_tx.serialNumber);
pa_tables = PA_Tables(pa_models);

%% Plots
try
    plot_results('psd', 'PA Input', signal.pre_pa.up_td_scaled, signal.settings.sampling_rate * signal.settings.upsample_rate);
    plot_results('psd', 'PA Output', signal.post_pa.up_td_scaled, signal.settings.sampling_rate * signal.settings.upsample_rate);
    
    plot_results('am/am', 'Original Signal', signal.pre_pa.up_td_scaled, signal.post_pa.up_td_scaled);
    plot_results('model', '7th Order, 4 Taps', pa_models(7,4).transmit(signal.pre_pa.up_td_scaled), signal.pre_pa.up_td_scaled);
    
    plot_results('constellation', 'Original Symbols', signal.pre_pa.frequency_domain_symbols);
    plot_results('constellation', 'Received Symbols', signal.post_pa.frequency_domain_symbols);
end

%% Helper Functions
function [board, signal] = setup(params)
switch params.PA_board
    case 'WARP'
        params.nBoards = 1;            % Number of WARP boards
        board = WARP(params);
        params.desired_sampling_rate = 40e6;    % WARP board sampling rate.
    case 'none'
        board = PowerAmplifier(0, '', 5, 5);
        params.desired_sampling_rate = 40e6;    % WARP board sampling rate.
    case 'webRF'
        board = webRF();
        params.desired_sampling_rate = 200e6;   % webRF sampling rate.
end

switch params.signal_type
    case 'OFDM'
        signal = OFDM(params);
    case 'CA'
        signal = CarrierAggregation(params.signal_bw, params.desired_sampling_rate, ...
            params.number_of_symbols, params.use_random_signal, params.constellation);
    case 'WGN'
        signal = WhiteNoise(params);
end
end
