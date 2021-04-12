classdef Environment
    %% Environment summary
    
    
    %% Properties
    properties  (Constant, GetAccess = public)
        
        % environment data
        grav = 9.81
        rho = 1025
    end
    
    
    %% Methods
    methods (Static)
        
        % Constructor
        function obj = Environment()
        end
    end
end

