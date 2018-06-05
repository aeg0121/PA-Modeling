classdef PA_Tables
    %PA_Tables Class to contain all the tables.
    %   Construct the tables if they don't exist. If they do exist, then
    %   load them from memory and append the new models to them.
    
    properties
        tables
    end
    
    methods
        function obj = PA_Tables(pa_models)
            %PA_Tables Construct an instance of this class
            %   Detailed explanation goes here
            
            load_flag = 0; % Inital case for load flag.
            [MAX_NONLINEAR_ORDER, MAX_MEMORY_ORDER] =  size(pa_models);
            try
                %load a table if it exists
                load('evaluate_pa_models');
                load_flag = 1; % load was succesful
                
            catch
                for i = 1:2:MAX_NONLINEAR_ORDER
                    for j = 1:MAX_MEMORY_ORDER
                        index = sprintf('order%d%d',i,j);
                        obj.tables.(index) = array2table(zeros(1,j*(i+1)/2+1));
                        obj = obj.pa_model_table(pa_models(i,j), i, j);
                    end
                end
            end
            
            if load_flag
                for i = 1:2:MAX_NONLINEAR_ORDER
                    for j = 1:MAX_MEMORY_ORDER
                        index = sprintf('order%d%d',i,j);
                        obj.tables.(index) =  obj.pa_model_table_append(pa_models(i,j), obj.tables.(index));
                    end
                end
            end
            
            save('evaluate_pa_models','obj');
            
        end
        
        function obj = pa_model_table(obj, model, i, j)
            %pa_model_table. Extract the coeffs of the model and add to the
            %table.
            
            index = sprintf('order%d%d', i, j);
            for x = 1:length(model.PolyCoeffs)
                obj.tables.(index)(1, x) = {model.PolyCoeffs(x)};
            end
            obj.tables.(index)(1, x+1) = {model.mse_of_fit};
        end
        
        function table = pa_model_table_append(obj, model, table)
            if size(table,1) ~= 1
                table = table(1:end-5, :);
            end
            
            % make prototypes for new rows.
            new_row = table(end,:);
            [number_of_rows, ~] = size(table);
            new_row_index = number_of_rows + 1;
            
            med = table(1,:);
            absolute_average = table(1,:);
            sd = table(1,:);
            prct5 = table(1,:);
            prct95 = table(1,:);
            
            % Put the correct values in the new rows.
            for x = 1:length(model.PolyCoeffs)
                new_row(1,x) = {model.PolyCoeffs(x)};
                med(1,x) = {median([abs(table.(x)); abs(new_row.(x))])};
                absolute_average(1,x) = {mean([abs(table.(x)); abs(new_row.(x))])};
                sd(1,x) = {std([abs(table.(x));abs(new_row.(x))])};
                prct5(1,x) = {prctile([abs(table.(x)); abs(new_row.(x))], 5)};
                prct95(1,x) = {prctile([abs(table.(x)); abs(new_row.(x))], 95)};
            end
            
            new_row(1,x+1) = {model.mse_of_fit};
            med(1,x+1) = {median([table.(x+1);new_row.(x+1)])};
            absolute_average(1,x+1) = {mean([table.(x+1);new_row.(x+1)])};
            sd(1,x+1) = {std([abs(table.(x+1));abs(new_row.(x+1))])};
            prct5(1,x+1) = {prctile([abs(table.(x+1)); abs(new_row.(x+1))], 5)};
            prct95(1,x+1) = {prctile([abs(table.(x+1)); abs(new_row.(x+1))], 95)};
            new_row.Properties.RowNames(1) = {sprintf('Row%d', new_row_index)};
            med.Properties.RowNames(1) = {'Median'};
            absolute_average.Properties.RowNames(1) = {'Absolute Average'};
            sd.Properties.RowNames(1) = {'Standard Deviation'};
            prct5.Properties.RowNames(1) = {'5th Percentile'};
            prct95.Properties.RowNames(1) = {'95th Percentile'};
            table = [table;new_row;med;absolute_average;sd;prct5;prct95];
        end
    end
end

