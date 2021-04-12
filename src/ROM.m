classdef ROM < Plots & ModalAmp %& SolutionOpt
    %% ROM Summary 
    
    
    %% Properties
    
    % Constant parameters
    properties  (Constant)
        % beam data
        diam = 22.2/1000
        L = 2.552
        At = L*0.01
        EI = 0.056
        EA = 1200
        Tt = 38.36
        f1 = 0.83
        w1 = 2*pi*f1
        W1 = 2*w1
        mu = 1.19
    end
    
    
    % Values dependent on water immersion
    properties (SetAccess = private, GetAccess = public)
        
        % Immersed? 
        isImmersed (1,1) logical
        
        c       (1,1) double
        mu_d    (1,1) double
        mu_a    (1,1) double
        Cd      (1,1) double
        gamma   (1,1) double
        
        % Nondimensionals
        m       (1,1) double
        Ca      (1,1) double
        L_m     (1,1) double
                
        
        a double  % alphas
        b double  % betas
        g double  % gammas
        ep double % epsilons
        d double  % deltas
    end
    
    
    
    %% Methods
    
    methods
        
        % Constructor
        function this = ROM(c, water)
            
            this.c = c;
            this.isImmersed = water;
            
            this.mu_d = Environment.rho*pi*diam^2/4;
            this.mu_a = this.mu_d;
            
            if water == false
                this.mu_a = 0;
                this.Cd = 0;
                this.gamma = this.mu * Environment.grav;
            else
                this.mu_a = this.mu_d;
                this.Cd = 1.2;
                this.gamma = this.mu * Environment.grav ...
                    - Environment.rho*Environment.grav*pi*this.diam^2/4;
            end
            
            
            % Lambda_M (Morison)
            this.L_m = this.diam^2/(this.L*this.mu_d*(this.m+this.Ca))*@Environment.rho*this.Cd;
            
            % Alphas
            this.a = [this.c/(this.mu_d*(this.m+this.Ca)*this.w1) ...
                -40*this.gamma/(9*this.mu_d*(this.m+this.Ca)*this.w1^2*this.L) ...
                this.diam^2*this.EA/(4*this.mu_d*(this.m+this.Ca)*this.w1^2)*(pi/this.L)^4 ...
                this.diam^2*this.EA/(this.mu_d*(this.m+this.Ca)*this.w1^2)*(pi/this.L)^4 ...
                9*this.diam^2*this.EA/(4*this.mu_d*(this.m+this.Ca)*this.w1^2)*(pi/this.L)^4];
            
            % Betas
            this.b = [this.a(1) ...
                -312*this.gamma/(25*this.mu_d*(this.m+this.Ca)*this.w1^2*this.L) ...
                this.a(2) ...
                this.a(4) ...
                this.diam^2*this.EA/(4*this.mu_d*(this.m+this.Ca)*this.w1^2)*(2*pi/this.L)^4 ...
                9*this.diam^2*this.EA/(this.mu_d*(this.m+this.Ca)*this.w1^2)*(pi/this.L)^4];
            
            % Gammas
            this.g = [this.a(1)
                this.b(2)
                this.b(6)
                this.a(5)
                this.diam^2*this.EA/(4*this.mu_d*(this.m+this.Ca)*this.w1^2)*(3*pi/this.L)^4];
            
            % Epsilons
            this.ep = [(EA/L)*(pi/L)^2*(At/(mu_d*(m+Ca)*w1^2)) ...
                (EA/L)*((2*pi)/L)^2*(At/(mu_d*(m+Ca)*w1^2)) ...
                (EA/L)*((3*pi)/L)^2*(At/(mu_d*(m+Ca)*w1^2))];
            
            % Deltas
            this.d = [(EI/(mu_d*(m+Ca)*w1^2))*(pi/L)^4-(1/2)*((gamma*L)/(mu_d*(m+Ca)*w1^2))*(pi/L)^2+(pi/L)^2*(Tt/(mu_d*(m+Ca)*w1^2)) ...
                (EI/(mu_d*(m+Ca)*w1^2))*(2*pi/L)^4-(1/2)*((gamma*L)/(mu_d*(m+Ca)*w1^2))*(2*pi/L)^2+(2*pi/L)^2*(Tt/(mu_d*(m+Ca)*w1^2)) ...
                (EI/(mu_d*(m+Ca)*w1^2))*(3*pi/L)^4-(1/2)*((gamma*L)/(mu_d*(m+Ca)*w1^2))*(3*pi/L)^2+(3*pi/L)^2*(Tt/(mu_d*(m+Ca)*w1^2))];
        end
        
        
        
        
        function this = OpenTabularPlot(this,tabGroupName)
            figure('Name',tabGroupName,'units', 'normalized', 'position', this.pos, 'color', 'w');
            uitabgroup;
        end
        
        
        function this = Plot(this, data, name, lines, labels, lgnd)
            
            if isempty(data)
                error('ROM object with contains no data to plot');
            end
            
            
            
        end
        
        
        
    end
end

