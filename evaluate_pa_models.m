function [pa_models, pa_tables] = evaluate_pa_models(signal,number)
%evaluate_pa_models Create models with different nonlinear orders and
%memory depths. Plot the MSE of each and return a good model.

MAX_NONLINEAR_ORDER = 9;
MAX_MEMORY_ORDER = 4;


%% LMS based memoryless models
pa_models(MAX_NONLINEAR_ORDER, MAX_MEMORY_ORDER) = PowerAmplifier; %preallocate
mse_transpose = zeros(MAX_MEMORY_ORDER, (MAX_NONLINEAR_ORDER+1)/2); %Row major for speed

counter = 1;
for i = 1:2:MAX_NONLINEAR_ORDER
    for j = 1:MAX_MEMORY_ORDER      
        pa_models(i,j) = PowerAmplifier(1, signal, i, j);
        mse_transpose(counter) = pa_models(i,j).mse_of_fit;
        counter = counter + 1;
    end
end

% Arrange in the order I need for bar graph.
mse = mse_transpose';
plot_results('mse', mse);

pa_tables = PA_Tables(pa_models);

end