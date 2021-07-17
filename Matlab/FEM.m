classdef FEM < Plots & handle
    %FEM Summary of this class goes here
    %   Detailed explanation goes here
    
    %% Properties
    properties
        
        % Immersed? 
        isImmersed (1,1) logical
        
        % Time series readed from file
        time (:,1) double
        timestep (1,1) double
        delay (1,1) double
        
        % Snapshots sample
        sample (1,1) double
        
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
        
        % Scalogram data
        scalogram
        
        % Directory with monitors data
        dir
    end
    
    
    properties (Constant)
        titles = ["u(L/4)" "u(L/2)" "u(3L/4)"]
        labels = struct('u',["$ u(L/4,\tau)/D $" "$ u(L/2,\tau)/D $" "$ u(3L/4,\tau)/D $"],...
            'du',[" $u'(L/4,\tau)/D $" "$ u'(L/2,\tau)/D $" "$ u'(3L/4,\tau)/D $"])
        
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
        function this = FEM(bool_immersed, files_dir, f, timestep, sample)
            
            global beamData
            this.f = f;
            this.isImmersed = bool_immersed;
            
            this.dir = files_dir;
            
            %-- Giraffe delay
            this.delay = 4; % seconds
            
            %-- Giraffe timestep
            this.timestep = timestep;
            this.sample = sample;
            
            % Read data
            for cont = 1:3
                inpt = readtable(strcat(this.dir,'monitor_node_',...
                    num2str(this.nodes(cont))),'HeaderLines',1);
                
                % Initial delay to match Giraffe and ROM time
                if cont == 1
                    this.time = (table2array(inpt(:,1))-this.delay)*(2*pi*this.f);
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
                        -this.delay)*(2*pi*this.f);
                end
                
                
                % Creates arrays with data from the table - match ROM nondimensional
                this.U{cont} = table2array(inpt(this.permaRegInit:size(inpt,1),3)) / beamData.d;
                this.dU{cont} = table2array(inpt(this.permaRegInit:size(inpt,1),21)) / (beamData.d* 2*pi*this.f);
                
            end
        end
        
        
        %%=== Functions ===%%
        
        %% Setting plot/save options
        function SetOutputOptions(this, save_disp, save_tension, ...
                save_scalogram , plot_scalogram)
            % Saving options
            this.out_bools.save_disp = save_disp;
            this.out_bools.save_tension = save_tension;
            this.out_bools.save_scalogram = save_scalogram ;
            
            % Plot options
            this.out_bools.phaseSpace = false;
            this.out_bools.plot_scalogram = plot_scalogram;
        end
        
        
        %% Plot data in multiple tabs
        function PlotResults(this, k, bool_open_tab, nPlots)
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
            set(gca, 'fontsize', this.FontSize, ...
                'xlim', GeneralOptions.SolOpt.permaPlot, ...
                'TickLabelInterpreter',Plots.interpreter)
            xlabel(Plots.defAxis('tau'),'FontName',this.FontName, ...
                'FontSize',this.FontSize, 'Interpreter',Plots.interpreter)
            ylabel(this.labels.u(k),'FontName',this.FontName, ...
                'FontSize',this.FontSize, 'Interpreter',Plots.interpreter)
            
            
            plot(this.time, this.U{k}, this.markers(2+2*this.isImmersed))
            
            % Frequency spectrum
            if nPlots == 3; subplot(2,2,4)
            else;           subplot(2,1,2)
            end
            
            hold on; box on;
            set(gca, 'FontName', this.FontName, 'fontsize',this.FontSize,...
                'xlim',this.lim_plot_freq, ...
                'TickLabelInterpreter',Plots.interpreter)
            xlabel(Plots.defAxis('f'), 'FontName', this.FontName,  ...
                'FontSize',this.FontSize, 'Interpreter',Plots.interpreter)
            ylabel(Plots.defAxis('Su'), 'FontName', this.FontName,  ...
                'FontSize',this.FontSize, 'Interpreter',Plots.interpreter)
            
            
            plot(this.Freq{k}, this.Ampl{k}, this.markers(2+2*this.isImmersed));
            
            
            % Phase space
            subplot(2,2,[1 3])
            hold on; box on;
            set(gca, 'FontName',this.FontName, 'FontSize',this.FontSize,...
                'TickLabelInterpreter',Plots.interpreter)
            xlabel(this.labels.u(k), 'FontName',this.FontName, ...
                'FontSize',this.FontSize, 'Interpreter',Plots.interpreter)
            ylabel(this.labels.du(k), 'FontName',this.FontName, ...
                'FontSize',this.FontSize, 'Interpreter',Plots.interpreter)
            
            
            plot(this.U{k}(this.plot_range(1):this.plot_range(2),1), ...
                this.dU{k}(this.plot_range(1):this.plot_range(2),1), ...
                this.markers(2+2*this.isImmersed));
            
        end
        
        
        %% Set tensions
        function SetTensions(this, loc)
            % Bottom
            if loc == 1
                % Top
                inpt = readtable(strcat(this.dir,'monitor_element_',...
                    num2str(this.elements(2)) ), 'HeaderLines',1);
                this.Tension_top = ...
                    table2array(inpt(this.permaRegInit:size(inpt,1),4));
            elseif loc == 2
                % Bottom
                inpt = readtable(strcat(this.dir,'monitor_element_',...
                    num2str(this.elements(1)) ), 'HeaderLines',1);
                this.Tension_bottom = ...
                    table2array(inpt(this.permaRegInit:size(inpt,1),4));
            else
                error("invalid option to set tension. It MUST be 1 (top) or 2 (bottom)")
            end
            
        end
        
        %% Print bottom/top tensions
        function PlotTensions(this, loc)
            if loc == 1
                plot(this.time, this.Tension_top, ...
                    this.markers(2+2*this.isImmersed)); % red
            elseif loc == 2
                plot(this.time, this.Tension_bottom, ...
                    this.markers(2+2*this.isImmersed)); % blue
            else
                error("invalid option to plottension. It MUST be 1 (top) or 2 (bottom)")
            end
        end
        
        
        function SetScalogram(this)
            global beamData
            
            % Range to plot scalogram
            this.scalogram.dTau = GeneralOptions.SolOpt.permaPlot(2) - ...
                GeneralOptions.SolOpt.permaPlot(1);
            
            % Time step
            this.timestep = this.time(2) - this.time(1); %nondimensional
            
            % range to plot
            %try to get a simmetric range equivalent to 5*plot_range
            
            %-- end time (nondimensional) -> ensure that a valid data is plotted
            this.scalogram.plotFinish = min([this.time(this.plot_range(2)) + ...
                this.timestep + 2*this.scalogram.dTau, SolutionOpt.tf]);
            this.scalogram.plotBegin = this.time(this.plot_range(1)) - this.timestep ...
                - 2*this.scalogram.dTau;
            
            %-- Min/Max solution snapshot (post)
            this.scalogram.begin = floor(...
                ( (this.scalogram.plotBegin/(2*pi*this.f)) ...
                - this.delay ) / (this.timestep/(2*pi*this.f)*this.sample)...
                );
            this.scalogram.finish = ceil(...
                ( (this.scalogram.plotFinish/(2*pi*this.f)) ...
                - this.delay ) / (this.timestep/(2*pi*this.f)*this.sample)...
                );
            
            this.scalogram.data = zeros(this.nodes(size(this.nodes,2)),...
                this.scalogram.finish-this.scalogram.begin+1);

            % Matrix with time series data
            % id offset
            offset = this.scalogram.begin - 1;
            for id = this.scalogram.begin:this.scalogram.finish
                this.scalogram.data(:,id-offset) = readmatrix(strcat(this.dir,...
                    'scalogram\solution_5_configuration_',num2str(id)),...
                    'Range','F3:F43') / beamData.d;
            end
        end
        
        
        function PlotScalogram(this, open_tab)
            
            % Open new tab
            if open_tab == true
                if this.isImmersed; tabName = 'Scalogram-FEM-water';
                else;               tabName = 'Scalogram-FEM-air';  end
                
                thistab = uitab('Title', tabName, 'BackgroundColor','w');
                axes('Parent',thistab); % somewhere to plot
            end
            
            % Plot data and change colors
            pcolor(linspace(...
                this.scalogram.plotBegin,this.scalogram.plotFinish,...
                size(this.scalogram.data,2) ),...
                linspace( 0,1,this.nodes(size(this.nodes,2)) ), ...
                this.scalogram.data)
            shading 'Interp'
            
            % Color bar plot
            cb = colorbar;
            cb.Label.String = '$ u(z/L,\tau)/D $';
            cb.Label.FontSize = this.FontSize;
            cb.Label.FontName = this.FontName;
            cb.Label.Interpreter = Plots.interpreter;
            set(cb,'TickLabelInterpreter',Plots.interpreter);
            
            colormap jet
            
            % Labels
            set(gca, 'FontName',this.FontName, 'FontSize',this.FontSize,...
                'xlim',[4960 5060],'TickLabelInterpreter',Plots.interpreter)
            xlabel(Plots.defAxis('tau'), 'FontName', this.FontName, ...
                'FontSize',this.FontSize, 'Interpreter',Plots.interpreter)
            ylabel(Plots.defAxis('z'), 'FontName', this.FontName, ...
                'FontSize', this.FontSize, 'Interpreter',Plots.interpreter)
            
%             % Adapt range to match a possible ROM scalogram 
%             %in practice, just exclude 'timestep'
%             newRange=[this.time(this.plot_range(1))-2*this.scalogram.dTau...
%                 min([this.time(this.plot_range(2))+2*this.scalogram.dTau,...
%                 SolutionOpt.tf])];
            
            
        end
                
    end
end

