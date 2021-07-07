classdef GeneralOptions < handle
    %% Summary
    %   Detailed explanation goes here
    
    
    %% Properties
    properties (Constant, GetAccess = public)
        % Objects
        Env =  Environment();
        SolOpt = SolutionOpt();
    end
    
    properties (GetAccess = public, SetAccess = protected)
        
        ROM_freq_air 
        ROM_freq_water 
        FEM_freq_air 
        FEM_freq_water 
        
        % Data to include
        include_FEM_water (1,1) logical
        include_FEM_air (1,1) logical
        include_ROM_water (1,1) logical
        include_ROM_air (1,1) logical
        
        % Show bottom/top tensions
        plot_tensions (1,1) logical
        
        % Plot in tabs
        plotTabs (1,1) logical
        
        % Save figures
        saveFigs (1,1) logical
        
        % Database
        export_data (1,1) logical
        load_data (1,1) logical
        
    end
    
    
    %% Methods
    
    methods (Static)
        
        %% Constructor
        function this = GeneralOptions(FEM_water, FEM_air, ...
                ROM_water,ROM_air, include_tension, plotTabs, saveFigs,...
                export_data, load_data)
            
            this.include_FEM_water = FEM_water;
            this.include_FEM_air = FEM_air;
            this.include_ROM_water = ROM_water;
            this.include_ROM_air = ROM_air;
            
            this.plot_tensions = include_tension;
            this.plotTabs = plotTabs;
            
            this.saveFigs = saveFigs;
            
            this.export_data = export_data;
            this.load_data = load_data;
            
            %-- General parameters 
            global beamData;
            beamData = struct('d',22.2/1000,'L',2.552,'At',0.01*2.552,...
                'EI',0.056,'EA',1200, 'mu',1.19,...
                'mu_d',this.Env.rho*pi*(22.2/1000)^2/4,...
                'm',1.19/(this.Env.rho*pi*(22.2/1000)^2/4));
            
            % Natural frequencies
            this.ROM_freq_air = containers.Map([2 4 6], 0.872436*[1 1 1]);
            this.ROM_freq_water = containers.Map([2 4 6], 0.755531*[1 1 1]);
            this.FEM_freq_air = containers.Map(...
                [2 4 6], 0.8101976649*[1 1 1]);
            this.FEM_freq_water = containers.Map(...
                [2 4 6], 0.7291838433*[1 1 1]);
%             this.FEM_freq_air = containers.Map(...
%                 [2 4 6], [0.8101976649 1.643449687 2.501329755]);
%             this.FEM_freq_water = containers.Map(...
%                 [2 4 6], [0.7291838433 1.470758398 2.229918562]);
        end
        
    end
end

