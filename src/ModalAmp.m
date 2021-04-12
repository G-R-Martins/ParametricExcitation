classdef ModalAmp < Plots
    %% Modal amplitude 
    %   Detailed explanation goes here
    
    properties
        A_tot double 
        Ak double 
    end
    
    
    properties (GetAccess = protected, SetAccess = private)
        save_respAmpli (1,1) logical = false;  % Resposta total
        save_respAmpli_Ak (1,1) logical = false; % Respostas modais
    end
    
    methods
        
        
        
        
        
        
        
        
         function Plot(~)
            disp("ploting. . .");
        end
        
        function SinglePlot(~, ~, ~, ~, ~, ~)
            error('ROM object can not use ''SinglePlot'' function');
        end
        
        
    end
end

