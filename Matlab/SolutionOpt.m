classdef SolutionOpt < handle
    %% SolutionOpt summary 
    properties (GetAccess = public, SetAccess = public)
        n_plot double
    end
    
    properties (Constant, GetAccess = public)
        % Initial conditions
        x0 = 0.1*[1;1;1;0;0;0];
        
        % Time 
        ti = 0;
        dt = 0.02;
        tf = 5050;
        permaTime = [1000 5050];      % permanent regime
        permaPlot = [5000 5050];    % plot range
        
        % Non-dimensional frequency - 'n'
        n0 = 2
        dn = 2  % MUST BE POSITIVE (DEFAULT: 2)
        nf = 6
    end
    
    %% Methods
    methods
        
        % Constructor
        function this = SolutionOpt()
        end
        
        
        % Options to plot
        function this = SetNs2Plot(nArray)
            this.n_plot = nArray;
        end
    end
end

