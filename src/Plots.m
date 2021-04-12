classdef Plots
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
        pos = [.1 0.1 .8 .8];
        figFormat = '-dpng'; % Format to save
    end
    

    %% Methods
    methods (Abstract)
        
        SinglePlot(this, data, name, lines, labels, lgnd)
        Plot(this)
        
    end
    
    
    methods
        
        
        %% Create window to include plots in different tabs
        function this = OpenTabularPlot(this,tabGroupName)
            figure('Name',tabGroupName,'units', 'normalized', 'position', this.pos, 'color', 'w');
            uitabgroup;
        end
        
        
        
        
%         %% Plot(s) in a single figure
%         function singlePlot(this, data, name, lines, labels, lgnd)
%             figure('Name',name,'units', 'normalized', 'position', this.pos, 'color', 'w');
%             hold on; box on;
%             
%             % PLot lines
%             for k=1:size(data,2)
%                 plot(data(:,k), z, lines(k));
%             end
%             
%             xlabel(labels(1), 'FontName', this.FontName, 'fontsize', this.FontSize);
%             ylabel(labels(2), 'FontName', this.FontName, 'fontsize', this.FontSize);
%             set(gca, 'FontName', this.FontName, 'fontsize', this.FontSize);
%             legend(lgnd, 'FontName', this.FontName, 'FontSize', this.FontSizeLegend, 'Location', loc);
%             
%         end
        
    end
end

