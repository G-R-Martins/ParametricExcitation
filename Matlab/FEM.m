classdef FEM < Plots & handle
    %FEM Summary of this class goes here
    %   Detailed explanation goes here
    
    %% Properties
    properties
        
        % Immersed? 
        isImmersed (1,1) logical
        
        % Time series readed from file
        time (:,1) double
        
        % Results
        U  cell   % displacement
        dU cell % TODO - mudar para 'cell' e colocar input do Giraffe
        
         % Spectrum
        Freq  cell    % frequency
        Ampl  cell    % amplitude
        Fd    (1,3) double  % dominant frequency
        Ad    (1,3) double  % dominant amplitude
        
        % Permanent regime
        %permaTime = []
        
        % Struct with output booleans 
        out_bools 
        
        % Frequency of the prescribed displacement
        f (1,1) double
        
        % First row with data to consider as permanent regime
        permaRegInit (1,1) double
        
        % Range to plot time series
        plot_range double
        
        % Tension top/bottom nodes
        Tension_top double
        Tension_bottom double
        
        % Directory with monitors data
        dir
    end
    
    
    properties (Constant)
        titles = ["u(L/4)" "u(L/2)" "u(3L/4)"]
        labels = struct('u',["u(L/4,\tau)/D" "u(L/2,\tau)/D" "u(3L/4,\tau)/D"],...
            'du',["u'(L/4,\tau)/D" "u'(L/2,\tau)/D" "u'(3L/4,\tau)/D"])
        
        % Directory of the Giraffe monitors
        data_dir = "..\Data\GiraffeData\"
        
        % Giraffe monitor nodes ID => [L/4  L/2  3L/4 L]
        nodes = [11 21 31 41]
        
        % Giraffe monitor elements ID => [bottom top]
        elements = [1 20]
    end
    
    
    %% Methods
    methods
        
        %% Constructor
        function this = FEM(bool_immersed, files_dir, f)
            
            global beamData
            this.f = f;
            this.isImmersed = bool_immersed;
            
            this.dir = files_dir;
            
            %-- Giraffe delay
            delay = 4; % seconds
            
            % Read data
            for cont = 1:3
                inpt = readtable(strcat(this.dir,'monitor_node_',...
                    num2str(this.nodes(cont))),'HeaderLines',1);
                
                % Initial delay to match Giraffe and ROM time
                if cont == 1
                    this.time = (table2array(inpt(:,1))-delay)*(2*pi*this.f);
                    [lin,~] = find(this.time(:,1) >= ...
                        GeneralOptions.SolOpt.permaTime(1));
                    
                    this.permaRegInit = lin(1);
                    this.time(1:lin(1)-1, :) = [];
                    
                    [id,~] = find(this.time(:,1) >= ...
                        GeneralOptions.SolOpt.permaPlot(1) & ...
                        this.time(:,1) <= GeneralOptions.SolOpt.permaPlot(2));
                    
                    this.plot_range = [id(1), id(size(id,1))];
                else
                    this.time = (table2array(inpt(this.permaRegInit:size(inpt,1),1))...
                        -delay)*(2*pi*this.f);
                end
                
                
                % Creates arrays with data from the table - match ROM nondimensional
                this.U{cont} = table2array(inpt(this.permaRegInit:size(inpt,1),3)) / beamData.d;
                this.dU{cont} = table2array(inpt(this.permaRegInit:size(inpt,1),21)) / (beamData.d* 2*pi*this.f);
                
            end
        end
        
        
        %%=== Functions ===%%
        
        %% Setting plot/save options
        function this = SetOutputOptions(this, save_disp, save_tension)
            % Saving options
            this.out_bools.save_disp = save_disp;
            this.out_bools.save_tension = save_tension;
            
            % Plot options
            this.out_bools.phaseSpace = false;
        end
        
        
        %% Plot data in multiple tabs
        function this = PlotResults(this, k, bool_open_tab, nPlots)
            % Open new tab
            if bool_open_tab == true
                thistab = uitab('Title',this.titles(k),'BackgroundColor', 'w'); % build iith tab
                axes('Parent',thistab); % somewhere to plot
            end
            
            % Displacement time series
            if nPlots == 3; subplot(2,2,2)
            else;           subplot(2,1,1)
            end
            
            hold on; box on;
            xlabel('\tau = t\omega_1','FontName',this.FontName,'FontSize',this.FontSize)
            ylabel(this.labels.u(k),'FontName',this.FontName,'FontSize',this.FontSize)
            set(gca, 'fontsize', this.FontSize, 'xlim', GeneralOptions.SolOpt.permaPlot)
            
            plot(this.time, this.U{k}, this.dots(1,2))
            
            % Frequency spectrum
            if nPlots == 3; subplot(2,2,4)
            else;           subplot(2,1,2)
            end
            
            hold on; box on;
            xlabel('f/f_1', 'FontName', this.FontName, 'fontsize', this.FontSize)
            ylabel("Amplitude", 'FontName', this.FontName, 'fontsize', this.FontSize)
            set(gca, 'FontName', this.FontName, 'fontsize', this.FontSize, 'xlim', this.lim_plot_freq)
            
            plot(this.Freq{k}, this.Ampl{k}, this.dots(1,2));
            
            
            % Phase space
            subplot(2,2,[1 3])
            hold on; box on;
            xlabel(this.labels.u(k), 'FontName', this.FontName, 'FontSize', this.FontSize)
            ylabel(this.labels.du(k), 'FontName', this.FontName, 'FontSize', this.FontSize)
            set(gca, 'FontName', this.FontName, 'FontSize', this.FontSize)
            
            plot(this.U{k}(this.plot_range(1):this.plot_range(2),1), ...
                this.dU{k}(this.plot_range(1):this.plot_range(2),1), ...
                this.dots(1,2));
            
        end
        
        
        %% Set tensions
        function this = SetTensions(this)
            % Bottom
            inpt = readtable(strcat(this.dir,'monitor_element_',...
                num2str(this.elements(1)) ), 'HeaderLines',1);
            this.Tension_bottom = ...
                table2array(inpt(this.permaRegInit:size(inpt,1),4));
            % Top 
            inpt = readtable(strcat(this.dir,'monitor_element_',...
                num2str(this.elements(2)) ), 'HeaderLines',1);
            this.Tension_top = ...
                table2array(inpt(this.permaRegInit:size(inpt,1),4));
        end
        
        %% Print bottom/top tensions
        function this = PlotTensions(this)
            plot(this.time/(2*pi*this.f), this.Tension_top, this.lines(3,1));
            plot(this.time/(2*pi*this.f), this.Tension_bottom, this.lines(3,2));
        end
        
                
    end
end

