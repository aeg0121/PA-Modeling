function [pa_model_92] = evaluate_pa_models(signal)
%evaluate_pa_models Create models with different nonlinear orders and
%memory depths. Plot the MSE of each and return a good model.

%% LMS based memoryless models
pa_model_11 = PowerAmplifier('', signal, 1, 1);
pa_model_12 = PowerAmplifier('', signal, 1, 2);
pa_model_13 = PowerAmplifier('', signal, 1, 3);
pa_model_14 = PowerAmplifier('', signal, 1, 4);

pa_model_31 = PowerAmplifier('', signal, 3, 1);
pa_model_32 = PowerAmplifier('', signal, 3, 2);
pa_model_33 = PowerAmplifier('', signal, 3, 3);
pa_model_34 = PowerAmplifier('', signal, 3, 4);

pa_model_51 = PowerAmplifier('', signal, 5, 1);
pa_model_52 = PowerAmplifier('', signal, 5, 2);
pa_model_53 = PowerAmplifier('', signal, 5, 3);
pa_model_54 = PowerAmplifier('', signal, 5, 4);

pa_model_71 = PowerAmplifier('', signal, 7, 1);
pa_model_72 = PowerAmplifier('', signal, 7, 2);
pa_model_73 = PowerAmplifier('', signal, 7, 3);
pa_model_74 = PowerAmplifier('', signal, 7, 4);

pa_model_91 = PowerAmplifier('', signal, 9, 1);
pa_model_92 = PowerAmplifier('', signal, 9, 2);
pa_model_93 = PowerAmplifier('', signal, 9, 3);
pa_model_94 = PowerAmplifier('', signal, 9, 4);



% Build up for a bar graph
mse = [pa_model_11.mse_of_fit pa_model_12.mse_of_fit pa_model_13.mse_of_fit pa_model_14.mse_of_fit;
   pa_model_31.mse_of_fit pa_model_32.mse_of_fit pa_model_33.mse_of_fit pa_model_34.mse_of_fit;
   pa_model_51.mse_of_fit pa_model_52.mse_of_fit pa_model_53.mse_of_fit pa_model_54.mse_of_fit;
   pa_model_71.mse_of_fit pa_model_72.mse_of_fit pa_model_73.mse_of_fit pa_model_74.mse_of_fit;
   pa_model_91.mse_of_fit pa_model_92.mse_of_fit pa_model_93.mse_of_fit pa_model_94.mse_of_fit];

plot_results('mse', mse);

end

