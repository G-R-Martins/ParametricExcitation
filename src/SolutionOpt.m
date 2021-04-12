classdef SolutionOpt
    %% SolutionOpt summary 
    
    
    properties (Constant, GetAccess = public)
        % Initial conditions
        x0 = 0.1*[1;1;1;0;0;0];
        
        % Time 
        ti = 0;
        dt = 0.05;
        tf = 10000;
        permaTime = [8000 8050]; % permanent regime
        
        % Non-dimensional frequency - 'n'
        n0 = 2
        dn = 1  % CAN NOT BE ZERO
        nf = 7
    end
    
    %% Methods
    methods (Static)
        
        % Constructor
        function obj = SolutionOpt()
        end
        
    end
end

