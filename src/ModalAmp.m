classdef ModalAmp < Plots & handle
    %% Modal amplitude 
    %   Detailed explanation goes here
    
    properties
        % Modal amplitude
        max_A_tot double  % amplitude
        max_A_k double    % 
        
        % Spectrum
        freq_A_k double   % 
        ampl_A_k double   % 
        Fd_A_k double     % 
        Ad_A_k double     % 
        
        
        % Struct with output booleans 
        out_bools 
        
        % Plot labels (not equals for all cases)
        labels
        
    end
    
    
    properties (GetAccess = public, SetAccess = private)
        save_A (1,1) logical = false;  % Resposta total
        save_Ak (1,1) logical = false; % Respostas modais
    end
    
    
    
    %% Methods
    methods
        
        function this = ModalAmp(bool_saveA, bool_saveAk)
            if nargin == 2
                this.save_A = bool_saveA;
                this.save_Ak = bool_saveAk;
            end
        end
        
        
        % Calculate frequency spectrum
        function this = CalculateSpectrum(this)
            [this.freq_A_k, this.ampl_A_k, this.Fd_A_k, this.Ad_A_k] = Spectrum(time, result);
        end
        
        
        % Set plot x,y-axes labels
        function this = SetPlotLabels(this, labels_disp, labels_vel)
            this.labels = struct('A',labels_disp, 'dA',labels_vel);
        end
        
        
        
        
        
        % Set plot x,y-axes labels
        function this = SetPlotLabels(this, labels_disp, labels_vel)
            this.labels.A = labels_disp;
            this.labels.dA = labels_vel;
        end
        
        function MultiTabPlot(~, ~)
            error('ROM object can not use ''SinglePlot'' function');
        end
                
        function SinglePlot(~, ~, ~)
            error('ROM object can not use ''SinglePlot'' function');
        end
        
        
    end
end

