function [pa_model_11,pa_model_11_table,pa_model_12,pa_model_12_table,...
    pa_model_13,pa_model_13_table,pa_model_14,pa_model_14_table,...
    pa_model_31,pa_model_31_table,pa_model_32,pa_model_32_table,...
    pa_model_33,pa_model_33_table,pa_model_34,pa_model_34_table,...
    pa_model_51,pa_model_51_table,pa_model_52,pa_model_52_table,...
    pa_model_53,pa_model_53_table,pa_model_54,pa_model_54_table,...
    pa_model_71,pa_model_71_table,pa_model_72,pa_model_72_table,...
    pa_model_73,pa_model_73_table,pa_model_74,pa_model_74_table,...
    pa_model_91,pa_model_91_table,pa_model_92,pa_model_92_table,...
    pa_model_93,pa_model_93_table,pa_model_94,pa_model_94_table] = evaluate_pa_models(signal,number)
%evaluate_pa_models Create models with different nonlinear orders and
%memory depths. Plot the MSE of each and return a good model.

%% LMS based memoryless models
pa_model_11 = PowerAmplifier(1, signal, 1, 1);
% pa_model_11_table = table(0,0,'RowNames',{num2str(number)});
% pa_model_11_table = pa_model_table(pa_model_11, pa_model_11_table);
pa_model_12 = PowerAmplifier(1, signal, 1, 2);
% pa_model_12_table = table(0,0,0,'RowNames',{num2str(number)});
% pa_model_12_table = pa_model_table(pa_model_12, pa_model_12_table);
pa_model_13 = PowerAmplifier(1, signal, 1, 3);
% pa_model_13_table = table(0,0,0,0,'RowNames',{num2str(number)});
% pa_model_13_table = pa_model_table(pa_model_13, pa_model_13_table);
pa_model_14 = PowerAmplifier(1, signal, 1, 4);
% pa_model_14_table = table(0,0,0,0,0,'RowNames',{num2str(number)});
% pa_model_14_table = pa_model_table(pa_model_14, pa_model_14_table);

pa_model_31 = PowerAmplifier(1, signal, 3, 1);
% pa_model_31_table = table(0,0,0,'RowNames',{num2str(number)});
% pa_model_31_table = pa_model_table(pa_model_31, pa_model_31_table);
pa_model_32 = PowerAmplifier(1, signal, 3, 2);
% pa_model_32_table = table(0,0,0,0,0,'RowNames',{num2str(number)});
% pa_model_32_table = pa_model_table(pa_model_32, pa_model_32_table);
pa_model_33 = PowerAmplifier(1, signal, 3, 3);
% pa_model_33_table = table(0,0,0,0,0,0,0,'RowNames',{num2str(number)});
% pa_model_33_table = pa_model_table(pa_model_33, pa_model_33_table);
pa_model_34 = PowerAmplifier(1, signal, 3, 4);
% pa_model_34_table = table(0,0,0,0,0,0,0,0,0,'RowNames',{num2str(number)});
% pa_model_34_table = pa_model_table(pa_model_34, pa_model_34_table);

pa_model_51 = PowerAmplifier(1, signal, 5, 1);
% pa_model_51_table = table(0,0,0,0,'RowNames',{num2str(number)});
% pa_model_51_table = pa_model_table(pa_model_51, pa_model_51_table);
pa_model_52 = PowerAmplifier(1, signal, 5, 2);
% pa_model_52_table = table(0,0,0,0,0,0,0,'RowNames',{num2str(number)});
% pa_model_52_table = pa_model_table(pa_model_52, pa_model_52_table);
pa_model_53 = PowerAmplifier(1, signal, 5, 3);
% pa_model_53_table = table(0,0,0,0,0,0,0,0,0,0,'RowNames',{num2str(number)});
% pa_model_53_table = pa_model_table(pa_model_53, pa_model_53_table);
pa_model_54 = PowerAmplifier(1, signal, 5, 4);
% pa_model_54_table = table(0,0,0,0,0,0,0,0,0,0,0,0,0,'RowNames',{num2str(number)});
% pa_model_54_table = pa_model_table(pa_model_54, pa_model_54_table);

pa_model_71 = PowerAmplifier(1, signal, 7, 1);
% pa_model_71_table = table(0,0,0,0,0,'RowNames',{num2str(number)});
% pa_model_71_table = pa_model_table(pa_model_71, pa_model_71_table);
pa_model_72 = PowerAmplifier(1, signal, 7, 2);
% pa_model_72_table = table(0,0,0,0,0,0,0,0,0,'RowNames',{num2str(number)});
% pa_model_72_table = pa_model_table(pa_model_72,pa_model_72_table);
pa_model_73 = PowerAmplifier(1, signal, 7, 3);
% pa_model_73_table = table(0,0,0,0,0,0,0,0,0,0,0,0,0,'RowNames',{num2str(number)});
% pa_model_73_table = pa_model_table(pa_model_73, pa_model_73_table);
pa_model_74 = PowerAmplifier(1, signal, 7, 4);
% pa_model_74_table = table(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,'RowNames',{num2str(number)});
% pa_model_74_table = pa_model_table(pa_model_74, pa_model_74_table);

pa_model_91 = PowerAmplifier(1, signal, 9, 1);
% pa_model_91_table = table(0,0,0,0,0,0,'RowNames',{num2str(number)});
% pa_model_91_table = pa_model_table(pa_model_91, pa_model_91_table);
pa_model_92 = PowerAmplifier(1, signal, 9, 2);
% pa_model_92_table = table(0,0,0,0,0,0,0,0,0,0,0,'RowNames',{num2str(number)});
% pa_model_92_table = pa_model_table(pa_model_92,pa_model_92_table);
pa_model_93 = PowerAmplifier(1, signal, 9, 3);
% pa_model_93_table = table(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,'RowNames',{num2str(number)});
% pa_model_93_table = pa_model_table(pa_model_93, pa_model_93_table);
pa_model_94 = PowerAmplifier(1, signal, 9, 4);
% pa_model_94_table = table(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,'RowNames',{num2str(number)});
% pa_model_94_table = pa_model_table(pa_model_94, pa_model_94_table);


try 
    load('evaluate_pa_models');
    pa_model_11_table = pa_model_table_append(pa_model_11, pa_model_11_table);
    pa_model_12_table = pa_model_table_append(pa_model_12, pa_model_12_table);
    pa_model_13_table = pa_model_table_append(pa_model_13, pa_model_13_table);
    pa_model_14_table = pa_model_table_append(pa_model_14, pa_model_14_table);
    pa_model_31_table = pa_model_table_append(pa_model_31, pa_model_31_table);
    pa_model_32_table = pa_model_table_append(pa_model_32, pa_model_32_table);
    pa_model_33_table = pa_model_table_append(pa_model_33, pa_model_33_table);
    pa_model_34_table = pa_model_table_append(pa_model_34, pa_model_34_table);
    pa_model_51_table = pa_model_table_append(pa_model_51, pa_model_51_table);
    pa_model_52_table = pa_model_table_append(pa_model_52, pa_model_52_table);
    pa_model_53_table = pa_model_table_append(pa_model_53, pa_model_53_table);
    pa_model_54_table = pa_model_table_append(pa_model_54, pa_model_54_table);
    pa_model_71_table = pa_model_table_append(pa_model_71, pa_model_71_table);
    pa_model_72_table = pa_model_table_append(pa_model_72, pa_model_72_table);
    pa_model_73_table = pa_model_table_append(pa_model_73, pa_model_73_table);
    pa_model_74_table = pa_model_table_append(pa_model_74, pa_model_74_table);
    pa_model_91_table = pa_model_table_append(pa_model_91, pa_model_91_table);
    pa_model_92_table = pa_model_table_append(pa_model_92, pa_model_92_table);
    pa_model_93_table = pa_model_table_append(pa_model_93, pa_model_93_table);
    pa_model_94_table = pa_model_table_append(pa_model_94, pa_model_94_table); 
    save('evaluate_pa_models','pa_model_11_table', 'pa_model_12_table', 'pa_model_13_table', 'pa_model_14_table',...)
        'pa_model_31_table', 'pa_model_32_table', 'pa_model_33_table', 'pa_model_34_table', ...
        'pa_model_51_table', 'pa_model_52_table', 'pa_model_53_table', 'pa_model_54_table', ...
        'pa_model_71_table', 'pa_model_72_table', 'pa_model_73_table', 'pa_model_74_table', ...
        'pa_model_91_table', 'pa_model_92_table', 'pa_model_93_table', 'pa_model_94_table')    
catch

    pa_model_11_table = table(0,0,'RowNames',{num2str(number)});
    pa_model_11_table = pa_model_table(pa_model_11, pa_model_11_table);
    pa_model_12_table = table(0,0,0,'RowNames',{num2str(number)});     
    pa_model_12_table = pa_model_table(pa_model_12, pa_model_12_table);
    pa_model_13_table = table(0,0,0,0,'RowNames',{num2str(number)});
    pa_model_13_table = pa_model_table(pa_model_13, pa_model_13_table);
    pa_model_14_table = table(0,0,0,0,0,'RowNames',{num2str(number)});
    pa_model_14_table = pa_model_table(pa_model_14, pa_model_14_table);
    pa_model_31_table = table(0,0,0,'RowNames',{num2str(number)});
    pa_model_31_table = pa_model_table(pa_model_31, pa_model_31_table);
    pa_model_32_table = table(0,0,0,0,0,'RowNames',{num2str(number)});
    pa_model_32_table = pa_model_table(pa_model_32, pa_model_32_table);
    pa_model_33_table = table(0,0,0,0,0,0,0,'RowNames',{num2str(number)});
    pa_model_33_table = pa_model_table(pa_model_33, pa_model_33_table);
    pa_model_34_table = table(0,0,0,0,0,0,0,0,0,'RowNames',{num2str(number)});
    pa_model_34_table = pa_model_table(pa_model_34, pa_model_34_table);
    pa_model_51_table = table(0,0,0,0,'RowNames',{num2str(number)});
    pa_model_51_table = pa_model_table(pa_model_51, pa_model_51_table);
    pa_model_52_table = table(0,0,0,0,0,0,0,'RowNames',{num2str(number)});
    pa_model_52_table = pa_model_table(pa_model_52, pa_model_52_table);
    pa_model_53_table = table(0,0,0,0,0,0,0,0,0,0,'RowNames',{num2str(number)});
    pa_model_53_table = pa_model_table(pa_model_53, pa_model_53_table);
    pa_model_54_table = table(0,0,0,0,0,0,0,0,0,0,0,0,0,'RowNames',{num2str(number)});
    pa_model_54_table = pa_model_table(pa_model_54, pa_model_54_table);
    pa_model_71_table = table(0,0,0,0,0,'RowNames',{num2str(number)});
    pa_model_71_table = pa_model_table(pa_model_71, pa_model_71_table);
    pa_model_72_table = table(0,0,0,0,0,0,0,0,0,'RowNames',{num2str(number)});
    pa_model_72_table = pa_model_table(pa_model_72,pa_model_72_table);
    pa_model_73_table = table(0,0,0,0,0,0,0,0,0,0,0,0,0,'RowNames',{num2str(number)});
    pa_model_73_table = pa_model_table(pa_model_73, pa_model_73_table);
    pa_model_74_table = table(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,'RowNames',{num2str(number)});
    pa_model_74_table = pa_model_table(pa_model_74, pa_model_74_table);
    pa_model_91_table = table(0,0,0,0,0,0,'RowNames',{num2str(number)});
    pa_model_91_table = pa_model_table(pa_model_91, pa_model_91_table);
    pa_model_92_table = table(0,0,0,0,0,0,0,0,0,0,0,'RowNames',{num2str(number)});
    pa_model_92_table = pa_model_table(pa_model_92,pa_model_92_table);
    pa_model_93_table = table(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,'RowNames',{num2str(number)});
    pa_model_93_table = pa_model_table(pa_model_93, pa_model_93_table);
    pa_model_94_table = table(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,'RowNames',{num2str(number)});
    pa_model_94_table = pa_model_table(pa_model_94, pa_model_94_table);
    save('evaluate_pa_models','pa_model_11_table', 'pa_model_12_table', 'pa_model_13_table', 'pa_model_14_table',...)
        'pa_model_31_table', 'pa_model_32_table', 'pa_model_33_table', 'pa_model_34_table', ...
        'pa_model_51_table', 'pa_model_52_table', 'pa_model_53_table', 'pa_model_54_table', ...
        'pa_model_71_table', 'pa_model_72_table', 'pa_model_73_table', 'pa_model_74_table', ...
        'pa_model_91_table', 'pa_model_92_table', 'pa_model_93_table', 'pa_model_94_table')
    
end


% Build up for a bar graph
mse = [pa_model_11.mse_of_fit pa_model_12.mse_of_fit pa_model_13.mse_of_fit pa_model_14.mse_of_fit;
   pa_model_31.mse_of_fit pa_model_32.mse_of_fit pa_model_33.mse_of_fit pa_model_34.mse_of_fit;
   pa_model_51.mse_of_fit pa_model_52.mse_of_fit pa_model_53.mse_of_fit pa_model_54.mse_of_fit;
   pa_model_71.mse_of_fit pa_model_72.mse_of_fit pa_model_73.mse_of_fit pa_model_74.mse_of_fit;
   pa_model_91.mse_of_fit pa_model_92.mse_of_fit pa_model_93.mse_of_fit pa_model_94.mse_of_fit];

plot_results('mse', mse);

end

function table = pa_model_table(model,table)
for x = 1:length(model.PolyCoeffs)
    table(1,x) = {model.PolyCoeffs(x)};
end
table(1,x+1) = {model.mse_of_fit};
end

function table = pa_model_table_append(model,table)
ttable = table(1,:);
for x = 1:length(model.PolyCoeffs)
    ttable(1,x) = {model.PolyCoeffs(x)};
end
ttable(1,x+1) = {model.mse_of_fit};
ttable.Properties.RowNames(1) = {num2str(rand)};
table = [table;ttable];
end



