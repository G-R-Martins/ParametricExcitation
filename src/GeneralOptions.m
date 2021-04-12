classdef GeneralOptions 
    %% Summary
    %   Detailed explanation goes here
    
    
    %% Properties
    properties
        
        include_FEM_water (1,1) logical
        include_FEM_air (1,1) logical
        include_ROM_water (1,1) logical
        include_ROM_air (1,1) logical
        
        Env (1,1) Environment
        SolOpt (1,1) SolutionOpt
        Plts (1,1) Plots
    end
    
    
    %% Methods
    
    methods    
        
        % Constructor
        function obj = GeneralOptions(FEM_water,FEM_air,ROM_water,ROM_air)
            
            obj.include_FEM_water = FEM_water;
            obj.include_FEM_air = FEM_air;
            obj.include_ROM_water = ROM_water;
            obj.include_ROM_air = ROM_air;
            
            obj.Env = Environment();
            obj.Plts = Plots();
            obj.SolOpt = SolutionOpt();
        end
        
    end
end

