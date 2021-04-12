classdef GeneralResults < Plots & ROM
    %RESULTS_UA Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        % Save options
        save_fig (1,1) logical = false;
        save_scalogram (1,1) logical = false;
        
        % Plot options
        bool_plt_phaseSpace (1,1) logical = false;
        plt_name
        
        % Solver options
        t_sol
        x_sol
    end
    
    
    methods
        
        
        function this = SolveSystemEqs(this, n)
            t = SolutionOpt.ti:SolutionOpt.dt:SolutionOpt.tf;
            f = @(t,x) Integrator(t,x,n);
            [this.t_sol,this.x_sol] = ode45(f,t,x0);
        end
        
        
        function y=Integrator(t,x,n)
            
            y = zeros(6,1);
            
            % Velocities
            y(1,1)=x(4,1);
            y(2,1)=x(5,1);
            y(3,1)=x(6,1);
            
            % Acelerations
            y(4,1)=-this.a(1)*x(4,1) - (this.d(1)+this.ep(1)*cos(n*t))*x(1,1) ...
                -this.a(2)*x(2,1) - this.a(3)*x(1,1)^3 ...
                - this.a(4)*x(1,1)*x(2,1)^2 - this.a(5)*x(1,1)*x(3,1)^2 ...
                -coef*(ShapeFunctions.modes(1,:)*((x(4,1)*ShapeFunctions.modes(1,:)+...
                x(5,1)*ShapeFunctions.modes(2,:)+x(6,1)*ShapeFunctions.modes(3,:)).*abs(x(4,1)*ShapeFunctions.modes(1,:)...
                +x(5,1)*ShapeFunctions.modes(2,:)+x(6,1)*ShapeFunctions.modes(3,:)))');
            
            y(5,1)=-this.b(1)*x(5,1) - (this.this.d(2)+this.ep(2)*cos(n*t))*x(2,1)...
                -this.b(2)*x(3,1) - this.b(3)*x(1,1) - this.b(4)*x(2,1)*x(1,1)^2 ...
                - this.b(5)*x(2,1)^3-this.b(6)*x(2,1)*x(3,1)^2 ...
                -coef*(ShapeFunctions.modes(2,:)*((x(4,1)*ShapeFunctions.modes(1,:)+...
                x(5,1)*ShapeFunctions.modes(2,:)+x(6,1)*ShapeFunctions.modes(3,:)).*abs(x(4,1)*ShapeFunctions.modes(1,:)...
                +x(5,1)*ShapeFunctions.modes(2,:)+x(6,1)*ShapeFunctions.modes(3,:)))');
            
            y(6,1)=-this.g(1)*x(6,1) - (this.d(3)+this.ep(3)*cos(n*t))*x(3,1)...
                -this.g(2)*x(2,1) - this.g(3)*x(3,1)*x(2,1)^2 ...
                - this.g(4)*x(3,1)*x(1,1)^2 - this.g(5)*x(3,1)^3 ...
                -coef*(ShapeFunctions.modes(3,:)*((x(4,1)*ShapeFunctions.modes(1,:)+...
                x(5,1)*ShapeFunctions.modes(2,:)+x(6,1)*ShapeFunctions.modes(3,:)).*abs(x(4,1)*ShapeFunctions.modes(1,:)...
                +x(5,1)*ShapeFunctions.modes(2,:)+x(6,1)*ShapeFunctions.modes(3,:)))');
            
        end
        
        
        
        function Plot(~)
            disp("ploting. . .");
        end
        
        function SinglePlot(~, ~, ~, ~, ~, ~)
            error('ROM object can not use ''SinglePlot'' function');
        end
        
%         
%         function obj = GeneralResults(inputArg1,inputArg2)
%             %RESULTS_UA Construct an instance of this class
%             %   Detailed explanation goes here
%             obj.Property1 = inputArg1 + inputArg2;
%         end
        
    end
end


