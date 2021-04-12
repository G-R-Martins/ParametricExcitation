classdef Results < ROM & Plot
    %RESULTS_UA Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        save_fig (1,1) logical = false;
        t_sol
        x_sol
    end
    
    methods
        
        
        function this = SolveSystemEqs(this, n)
            t = SolutionOpt.ti:SolutionOpt.dt:SolutionOpt.tf;
            f = @(t,x) Integrator(t,x,this.a,this.b,this.g,this.d,this.ep,n,this.modes);
            [this.t_sol,this.x_sol] = ode45(f,t,x0);
        end
        
        
        
        
        
        function obj = Results(inputArg1,inputArg2)
            %RESULTS_UA Construct an instance of this class
            %   Detailed explanation goes here
            obj.Property1 = inputArg1 + inputArg2;
        end
        
        function outputArg = method1(obj,inputArg)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            outputArg = obj.Property1 + inputArg;
        end
    end
end

