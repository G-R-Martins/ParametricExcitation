classdef GeneralOptions 
    %% Summary
    %   Detailed explanation goes here
    
    
    %% Properties
    properties
        
        % Objects
        Env (1,1) Environment
        SolOpt (1,1) SolutionOpt
                
        % Data to include
        include_FEM_water (1,1) logical
        include_FEM_air (1,1) logical
        include_ROM_water (1,1) logical
        include_ROM_air (1,1) logical
        
    end
    
    
    %% Methods
    
    methods    
        
        %% Constructor
        function this = GeneralOptions(FEM_water,FEM_air,ROM_water,ROM_air)
            
            this.include_FEM_water = FEM_water;
            this.include_FEM_air = FEM_air;
            this.include_ROM_water = ROM_water;
            this.include_ROM_air = ROM_air;
            
            this.Env = Environment();
            this.SolOpt = SolutionOpt();
            
        end
        
       
        % Get/set methods.
%         
%         function envObj = get.Env( this )
%             envObj = this.Env;
%         end %         
        
    end
end

