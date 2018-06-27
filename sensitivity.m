%% Sensitivity Analysis
% We seek to understand the sensitivity of the various coefficients. How
% much does a small epilon change in beta have on the performance of the
% model? 

%% Set up the experiment
params.PA_board = 'WARP';      % either 'WARP', 'webRF', or 'none'
params.signal_type = 'OFDM';    % either 'OFDM' or 'WGN' or 'CA'
params.use_random_signal = 1;   % 1 forces a new OFDM each time. 0 will use the same random OFDM signal
params.signal_bw = 5;          % Bandwidth of the OFDM of WGN signal
params.channel = 1+0i;

%Only used in OFDM
params.constellation = 'QPSK'; % Only used in OFDM
params.number_of_symbols = 30;

% Only used in WGN
params.number_of_samples = 10000;

[board, signal] =  setup(params);

% TX
signal = signal.transmit(board, params.channel);

pa_models = evaluate_pa_models(signal, board.node_tx.serialNumber);

%Extract this model.
pa_models74 = pa_models(7,4);

%Make a small changes in a box around each param.
original = pa_models74.PolyCoeffs(1);
y = signal.post_pa.upsampled_td;
count = 1;
mse = zeros(25,1);
for a =-1:0.5:1
    for b = -1:0.5:1
        pa_models74.PolyCoeffs(1) = original + a + b*1i;
        output = pa_models74.transmit(signal.pre_pa.upsampled_td);
        mse(count) = norm(y - output)^2/ norm(y)^2;
        count = count + 1;
    end
end

%% Helper Functions
function [board, signal] = setup(params)
switch params.PA_board
    case 'WARP'
        board = WARP(1);
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
        signal = OFDM(params.signal_bw, params.desired_sampling_rate, ...
            params.number_of_symbols, params.use_random_signal, params.constellation);
    case 'CA'
        signal = CarrierAggregation(params.signal_bw, params.desired_sampling_rate, ...
            params.number_of_symbols, params.use_random_signal, params.constellation);
    case 'WGN'
        signal = WhiteNoise(params.signal_bw, params.desired_sampling_rate, ...
            params.number_of_samples, params.use_random_signal);
end
end