classdef Plots < handle
    %% Plots summary 
    
    
    %% Save options
    properties (GetAccess = protected, SetAccess = protected)
    end
    
    
    %% Formatting options
    properties (Constant, GetAccess = protected)
        FontSize = 18;
        FontSizeLegend = 16;
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
        
        SinglePlot(this, data, name)
        MultiTabPlot(this, k)
        SetPlotLabels(this, xlabels, ylabels)
    end
    
    
    methods
        
        
        %% Create window to include plots in different tabs
        function this = OpenTabularPlot(this,tabGroupName)
            figure('Name',tabGroupName,'units', 'normalized', 'position', this.default_pos, 'color', 'w');
            uitabgroup;
        end
        
    end
end

