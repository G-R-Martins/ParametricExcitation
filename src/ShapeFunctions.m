classdef ShapeFunctions < Plots & handle
    %SHAPEFUNCTIONS Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (GetAccess = public, SetAccess = protected)
        
        % Booleans to show/print modes
        print_modes (1,1) logical = false
        save_fig (1,1) logical = false
        
        % Number of modes
        n_modes (1,1) = 3;
        % Discretization
        disc (1,1) = 1000;
        % Arguments of the shape functions sines
        sin_args
        % Beam nodes
        z
        % Modes
        modes
        
        % Plot options
        labels (1,2) string = ["\psi_k(z)" "z/L"];
        legends cell = {'k = 1','k = 2','k = 3'}
        plt_lines string = ["-k" "--r" "-.b"]
        dir_fig = '..\figs' 
    end
    
    methods (Static)
        %% Constructor
        function this = ShapeFunctions(L, n_modes, showFig)
            % Arguments of sinusoidal shape functions
            this.sin_args = [pi/L*L/4 pi/L*L/2 pi/L*3*L/4];
            
            % Vertical discretization
            this.z = linspace(0,L,this.disc);
            
            % Setting modes (shape functions)
            this.n_modes = n_modes;
            this.modes = zeros(n_modes,size(this.z,2));
            for ii = 1:1:n_modes
                this.modes(ii,:) = sin(ii*pi/L*this.z);
            end
            
            
            this.print_modes = showFig;
        end
    end
    
    %% Plot
    methods
        function this = SinglePlot(this, ~, name)
            global beamData
            
            % Creates directory to save figure
            [~,~] = mkdir(this.dir_fig);
            
            figure('Name',name,'units', 'normalized', 'position', [.1 .1 .5 .8], 'color', 'w');
            hold on; box on;
            
            % Ploting shape functions in the same figure
            for ii=1:3
                plot(this.modes(ii,:), this.z/beamData.L, this.plt_lines(ii));
            end
            
            xlabel(this.labels(1,1), 'FontName', this.FontName, 'fontsize', this.FontSize);
            ylabel(this.labels(1,2), 'FontName', this.FontName, 'fontsize', this.FontSize);
            legend(this.legends,'FontName', this.FontName, 'FontSize', this.FontSizeLegend, 'Location', 'southwest');
            
            % Save figure
            if this.save_fig == true
                set(gcf,'PaperSize', this.default_paperSize);
                print(fullfile(this.dir_fig, name), this.figFormat, '-r1000')
            end
            
            hold off
        end
        
        
        % Not allowed for ShapeFunctions
        function [] = MultiTabPlot(~)
            error('Shapae function object can not use ''MultTabPlot'' function. It is only allowed to plot shape functions in a single figure. \n Please, use ''SinglePlot'' function');
        end
                
    end
    
end

