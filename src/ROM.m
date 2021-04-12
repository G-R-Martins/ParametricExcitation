classdef ROM %< GeneralResults %& ModalAmp %& SolutionOpt
    %% ROM Summary 
    
    
    %% Properties
    
    % Constant parameters
    properties  (Constant)
%         % beam data
%         diam = 22.2/1000
%         L = 2.552
%         At = 2.552*0.01
%         EI = 0.056
%         EA = 1200
%         Tt = 38.36
%         f1 = 0.83
%         w1 = 2*pi*0.83
%         W1 = 2*2*pi*0.83
%         mu = 1.19
    end
    
    
    % Values dependent on water immersion
    properties (SetAccess = private, GetAccess = public)
        
        % Immersed? 
        isImmersed (1,1) logical
        
        c       (1,1) double
%         mu_d    (1,1) double
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
    
    properties
        mAmp ModalAmp
    end
    
    %% Methods
    
    methods
        
        % Constructor
        function this = ROM(c, bool_immersed, beamData)
            
            % Initialize modal amplitude object
            this.mAmp = ModalAmp(beamData.L, 3) ;
            
            this.c = c;
            this.isImmersed = bool_immersed;
            
%             beamData.mu_d = Environment.rho*pi*beamData.d^2/4;
%             this.mu_a = beamData.mu_d;
            
            if bool_immersed == false
                this.mu_a = 0;
                this.Cd = 0;
                this.gamma = beamData.mu * Environment.grav;
            else
                this.mu_a = beamData.mu_d;
                this.Cd = 1.2;
                this.gamma = beamData.mu * Environment.grav ...
                    - Environment.rho*Environment.grav*pi*beamData.d^2/4;
            end
                        
%             beamData.m = beamData.mu/beamData.mu_d;
            this.Ca = this.mu_a/beamData.mu_d;
                        
            % Lambda_M (Morison)
            this.L_m = beamData.d^2/(beamData.L*beamData.mu_d*(beamData.m+this.Ca))*Environment.rho*this.Cd;
            
            
            % Alphas
            this.a = [this.c/(beamData.mu_d*(beamData.m+this.Ca)*beamData.w1) ...
                -40*this.gamma/(9*beamData.mu_d*(beamData.m+this.Ca)*beamData.w1^2*beamData.L) ...
                beamData.d^2*beamData.EA/(4*beamData.mu_d*(beamData.m+this.Ca)*beamData.w1^2)*(pi/beamData.L)^4 ...
                beamData.d^2*beamData.EA/(beamData.mu_d*(beamData.m+this.Ca)*beamData.w1^2)*(pi/beamData.L)^4 ...
                9*beamData.d^2*beamData.EA/(4*beamData.mu_d*(beamData.m+this.Ca)*beamData.w1^2)*(pi/beamData.L)^4];
            
            % Betas
            this.b = [this.a(1) ...
                -312*this.gamma/(25*beamData.mu_d*(beamData.m+this.Ca)*beamData.w1^2*beamData.L) ...
                this.a(2) ...
                this.a(4) ...
                beamData.d^2*beamData.EA/(4*beamData.mu_d*(beamData.m+this.Ca)*beamData.w1^2)*(2*pi/beamData.L)^4 ...
                9*beamData.d^2*beamData.EA/(beamData.mu_d*(beamData.m+this.Ca)*beamData.w1^2)*(pi/beamData.L)^4];
            
            % Gammas
            this.g = [this.a(1)
                this.b(2)
                this.b(6)
                this.a(5)
                beamData.d^2*beamData.EA/(4*beamData.mu_d*(beamData.m+this.Ca)*beamData.w1^2)*(3*pi/beamData.L)^4];
            
            % Epsilons
            this.ep = [(beamData.EA/beamData.L)*(pi/beamData.L)^2*(beamData.At/(beamData.mu_d*(beamData.m+this.Ca)*beamData.w1^2)) ...
                (beamData.EA/beamData.L)*((2*pi)/beamData.L)^2*(beamData.At/(beamData.mu_d*(beamData.m+this.Ca)*beamData.w1^2)) ...
                (beamData.EA/beamData.L)*((3*pi)/beamData.L)^2*(beamData.At/(beamData.mu_d*(beamData.m+this.Ca)*beamData.w1^2))];
            
            % Deltas
            this.d = [(beamData.EI/(beamData.mu_d*(beamData.m+this.Ca)*beamData.w1^2))*(pi/beamData.L)^4-(1/2)*((this.gamma*beamData.L)/(beamData.mu_d*(beamData.m+this.Ca)*beamData.w1^2))*(pi/beamData.L)^2+(pi/beamData.L)^2*(beamData.Tt/(beamData.mu_d*(beamData.m+this.Ca)*beamData.w1^2)) ...
                (beamData.EI/(beamData.mu_d*(beamData.m+this.Ca)*beamData.w1^2))*(2*pi/beamData.L)^4-(1/2)*((this.gamma*beamData.L)/(beamData.mu_d*(beamData.m+this.Ca)*beamData.w1^2))*(2*pi/beamData.L)^2+(2*pi/beamData.L)^2*(beamData.Tt/(beamData.mu_d*(beamData.m+this.Ca)*beamData.w1^2)) ...
                (beamData.EI/(beamData.mu_d*(beamData.m+this.Ca)*beamData.w1^2))*(3*pi/beamData.L)^4-(1/2)*((this.gamma*beamData.L)/(beamData.mu_d*(beamData.m+this.Ca)*beamData.w1^2))*(3*pi/beamData.L)^2+(3*pi/beamData.L)^2*(beamData.Tt/(beamData.mu_d*(beamData.m+this.Ca)*beamData.w1^2))];
        end
        
        
        
%         
%         function this = Plot(this, data, name, lines, labels, lgnd)
%             
%             if isempty(data)
%                 error('ROM object with contains no data to plot');
%             end
%             
%             
%             
%         end
        
        
        
    end
end

