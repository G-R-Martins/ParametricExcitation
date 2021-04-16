classdef GeneralOptions 
    %% Summary
    %   Detailed explanation goes here
    
    
    %% Properties
    properties (Constant, GetAccess = public)%, SetAccess = protected)
        
        % Objects
        Env =  Environment();
        SolOpt = SolutionOpt();
    end
    
    properties (GetAccess = public, SetAccess = protected)
        % Data to include
        include_FEM_water (1,1) logical
        include_FEM_air (1,1) logical
        include_ROM_water (1,1) logical
        include_ROM_air (1,1) logical
    end
    
    
    %% Methods
    
    methods (Static)
        
        %% Constructor
        function this = GeneralOptions(FEM_water,FEM_air,ROM_water,ROM_air)
            
            this.include_FEM_water = FEM_water;
            this.include_FEM_air = FEM_air;
            this.include_ROM_water = ROM_water;
            this.include_ROM_air = ROM_air;
                      
            
            % Common parameters (immersed and in air)
            global beamData;
            beamData = struct('d',22.2/1000,'L',2.552,'At',0.01*2.552,...
                'EI',0.056,'EA',1200, 'Tt',38.36,'f1',0.83,'mu',1.19,...
                'w1',2*pi*0.83,'W1',2*2*pi*0.83,...
                'mu_d',this.Env.rho*pi*(22.2/1000)^2/4,'m',1.19/(this.Env.rho*pi*(22.2/1000)^2/4));
            
        end
        
       
        % Get/set methods.
%         
%         function envObj = get.Env( this )
%             envObj = this.Env;
%         end %         
        
    end
end

