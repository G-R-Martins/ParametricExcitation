classdef Plots < handle
    %% Plots summary 
    
    
    %% Save options
    properties (GetAccess = protected, SetAccess = protected)
    end
    
    
    %% Formatting options
    properties (Constant, GetAccess = public)
        FontSize = 16;
        FontSizeLegend = 14;
        FontName = "Cambria Math";
        MarkerSize = 15;
        default_pos = [.1 0.1 .8 .8];
        default_paperSize = [3.5 6];
        figFormat = '-dpng'; % Format to save
        
        lines = ["-k" "-r" "-g" "-b"; ...
            "--k" "--r" "--g" "--b";
            "-.k" "-.r" "-.g" "-.b"];
        dots = [".k" ".r" ".g" ".b"];
		
		lim_plot_freq = [0 6];
        
    end
    

    %% Methods
    methods (Abstract)
        PlotResults(this, k, open_tab) 
    end
    
    
    methods 
        
        
        %% Create window to include plots in different tabs
        function tab_group = OpenTabularPlot(this,tabGroupName)
            figure('Name',tabGroupName,'units','normalized','position', ...
                this.default_pos, 'color', 'w');
            tab_group = uitabgroup;
        end
        
        function fig = OpenSiglePlotFig(this,figTitle)
            fig = figure('Name',figTitle,'units','normalized','position', ...
                this.default_pos, 'color', 'w');
        end
        
    end
    
    methods (Static)
        function [] = OpenFig(figName, xlab, ylab, plot_lim, font, size)
            figure('Name',figName,'units', ...
                'normalized', 'position',[.1 .1 .5 .8], 'color','w');
            hold on; box on;
            
            xlabel(xlab,'FontName',font,'FontSize',size);
            ylabel(ylab,'FontName',font,'FontSize',size);
            set(gca, 'FontName',font, 'FontSize',size, 'xlim', plot_lim);
        end
        
    end
    
end

