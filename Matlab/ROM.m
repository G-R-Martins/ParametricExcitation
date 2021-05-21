classdef ROM < Plots & handle
    %% ROM Summary 
    
    
    %% Properties
       
    % Values dependent on water immersion
    properties (SetAccess = public, GetAccess = public)
        
        % Immersed? 
        isImmersed (1,1) logical
        
        c       (1,1) double
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
        
        % Solution of the ODEs
        t_sol double
        x_sol double
        
        % Time series 
        U  cell   % displacement
        V  cell   % velocities
        
        % Spectrum
        Freq  cell    % frequency
        Ampl  cell    % amplitude
        Fd    (1,3) double  % dominant frequency
        Ad    (1,3) double  % dominant amplitude
        
        % Struct with output booleans 
        out_bools 
        
        % Morison nondimensional
        mor_coef (1,1) double
        
    end
    
    properties (Constant)
        titles = ["u(L/4)" "u(L/2)" "u(3L/4)"];
        labels = struct('u',["u(L/4,\tau)/D" "u(L/2,\tau)/D" "u(3L/4,\tau)/D"],...
            'du',["u'(L/4,\tau)/D" "u'(L/2,\tau)/D" "u'(3L/4,\tau)/D"]);
        
    end
    
    properties
        genCoord GenModalCoord
    end
    
    %% Methods
    
    methods 
        
        %% Constructor
        function this = ROM(c, bool_immersed)
            global beamData
            
            % Initialize empty cells
            this.U{3} = {};% displacement
            this.V{3} = {}; % velocities
            this.Freq{3} = {}; % frequency
            this.Ampl{3} = {};% amplitude
            
            % Initialize modal amplitude object
            this.genCoord = GenModalCoord();
            
            this.c = c;
            this.isImmersed = bool_immersed;
            
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
        
        
        %% Functions
        
        % Setting plot/save options
        function this = SetOutputOptions(this, save_fig, save_scalogram, show_phaseSpace, show_scalogram)
            % Saving options
            this.out_bools.save_fig = save_fig;
            this.out_bools.save_scalogram = save_scalogram;
        
            % Plot options
            this.out_bools.phaseSpace = show_phaseSpace;
            this.out_bools.scalogram = show_scalogram;
        end
        
        
        % Evaluate displacements and velocities
        function this = CalculateResults(this, modes, k)
			sz = size(modes,2)*k/4;
            this.U{k} = this.x_sol(:,1)*modes(1,sz) + this.x_sol(:,2)*modes(2,sz) + this.x_sol(:,3)*modes(3,sz);
            this.V{k} = this.x_sol(:,1+3)*modes(1,sz) + this.x_sol(:,2+3)*modes(2,sz) + this.x_sol(:,3+3)*modes(3,sz);
        end
        
        
        % Solve the system equations
        function this = SolveSystemEqs(this, n, modes)
            t = GeneralOptions.SolOpt.ti:GeneralOptions.SolOpt.dt:GeneralOptions.SolOpt.tf;
            f = @(t,x) this.Integrator(t, x, n, modes);
            [this.t_sol, this.x_sol] = ode45(f, t, GeneralOptions.SolOpt.x0);
        end
        
        
        % Integrate equations of motion
        function y = Integrator(this,t,x,n, modes)
            
            % Initialize matrix to put results
            y = zeros(6,1);
            
            % Velocities
            y(1,1)=x(4,1);
            y(2,1)=x(5,1);
            y(3,1)=x(6,1);
            
            % Acelerations
            y(4,1)=-this.a(1)*x(4,1) - (this.d(1)+this.ep(1)*cos(n*t))*x(1,1) ...
                -this.a(2)*x(2,1) - this.a(3)*x(1,1)^3 ...
                - this.a(4)*x(1,1)*x(2,1)^2 - this.a(5)*x(1,1)*x(3,1)^2 ...
                -this.mor_coef*(modes(1,:)*((x(4,1)*modes(1,:)+...
                x(5,1)*modes(2,:)+x(6,1)*modes(3,:)).*abs(x(4,1)*modes(1,:)...
                +x(5,1)*modes(2,:)+x(6,1)*modes(3,:)))');
            
            y(5,1)=-this.b(1)*x(5,1) - (this.d(2)+this.ep(2)*cos(n*t))*x(2,1)...
                -this.b(2)*x(3,1) - this.b(3)*x(1,1) - this.b(4)*x(2,1)*x(1,1)^2 ...
                - this.b(5)*x(2,1)^3-this.b(6)*x(2,1)*x(3,1)^2 ...
                -this.mor_coef*(modes(2,:)*((x(4,1)*modes(1,:)+...
                x(5,1)*modes(2,:)+x(6,1)*modes(3,:)).*abs(x(4,1)*modes(1,:)...
                +x(5,1)*modes(2,:)+x(6,1)*modes(3,:)))');
            
            y(6,1)=-this.g(1)*x(6,1) - (this.d(3)+this.ep(3)*cos(n*t))*x(3,1)...
                -this.g(2)*x(2,1) - this.g(3)*x(3,1)*x(2,1)^2 ...
                - this.g(4)*x(3,1)*x(1,1)^2 - this.g(5)*x(3,1)^3 ...
                -this.mor_coef*(modes(3,:)*((x(4,1)*modes(1,:)+...
                x(5,1)*modes(2,:)+x(6,1)*modes(3,:)).*abs(x(4,1)*modes(1,:)...
                +x(5,1)*modes(2,:)+x(6,1)*modes(3,:)))');
            
        end
                
        
        % Calculate frequency spectrum
        function this = CalculateSpectrum(this,k)
            [this.Freq{k}, this.Ampl{k}, this.Fd(k), this.Ad(k)] = Spectrum(this.t_sol, this.U{k});
        end
        
        
%         % Set plot x,y-axes labels
%         function this = SetPlotLabels(this, labels_disp, labels_vel)
%             this.labels = struct('u',labels_disp, 'du',labels_vel);
%         end
%         
        
        % Plot in multiple tabs
        function this = MultiTabPlot(this, k)
            % Open new tab
            thistab = uitab('Title',this.titles(k),'BackgroundColor', 'w'); % build iith tab
            axes('Parent',thistab); % somewhere to plot
            
            if this.out_bools.phaseSpace == true
                % Displacement time series
                subplot(2,2,2)
                hold on; box on;
                xlabel('\tau = t\omega_1','FontName',this.FontName,'FontSize',this.FontSize)
                ylabel(this.labels.u(k),'FontName',this.FontName,'FontSize',this.FontSize)
                set(gca, 'fontsize', this.FontSize, 'xlim', GeneralOptions.SolOpt.permaTime)
                
                plot(this.t_sol, this.U{k}, this.lines(1,1))
                
                
                % Frequency spectrum
                subplot(2,2,4)
                hold on; box on;
                xlabel('f/f_1', 'FontName', this.FontName, 'FontSize', this.FontSize)
                ylabel("Amplitude", 'FontName', this.FontName, 'FontSize', this.FontSize)
                set(gca, 'FontName', this.FontName, 'FontSize', this.FontSize, 'xlim', this.lim_plot_freq)
                
                plot(this.Freq{k}, this.Ampl{k}, this.lines(1,1))
                
                % Phase space
                %%% Para plotar o espaço de fase do intervalo de interesse, deve-se extrair
                %%% os valores desse intervalo antes
                [lin,~] = find(this.t_sol(:,1) >= GeneralOptions.SolOpt.permaTime(1) ...
                    & this.t_sol(:,1) <= GeneralOptions.SolOpt.permaTime(2));
                begin = lin(1);
                finish = lin(size(lin,1));
                
                subplot(2,2,[1 3])
                hold on; box on;
                xlabel(this.labels.u(k), 'FontName', this.FontName, 'FontSize', this.FontSize)
                ylabel(this.labels.du(k), 'FontName', this.FontName, 'FontSize', this.FontSize)
                set(gca, 'FontName', this.FontName, 'FontSize', this.FontSize)
                
                plot(this.U{k}(begin:finish,1), this.V{k}(begin:finish,1), this.lines(1,1));
                
             else
                 % Displacement time series
                 subplot(2,1,1)
                 hold on; box on;
                 xlabel('\tau = t\omega_1', 'FontName', this.FontName, 'FontSize', this.FontSize);
                 ylabel(this.labels.u(k),'FontName', this.FontName, 'FontSize', this.FontSize);
                 set(gca, 'FontName', this.FontName, 'FontSize', this.FontSize, 'xlim', GeneralOptions.SolOpt.permaTime);
                 
                 plot(this.t_sol, this.U{k}, this.lines(1,1));
                 
                 
                 % Frequency spectrum
                 subplot(2,1,2)
                 hold on; box on;
                 xlabel('f/f_1', 'FontName', this.FontName, 'FontSize', this.FontSize)
                 ylabel('Amplitude', 'FontName', this.FontName, 'FontSize', this.FontSize)
                 set(gca, 'FontName', this.FontName, 'FontSize', this.FontSize, 'xlim', this.lim_plot_freq)
                 
                 plot(this.Freq{k}, this.Ampl{k}, this.lines(1,1))
            end
            
            
        end
        
        %%% TODO
        function this = SinglePlot(this, data, ~)
            if isempty(data)
                error('ROM object is supposed to use MultiTabPlot with contains no data to plot');
            end
        end
        
        
        %% Plot scalogram
        function this = PlotScalogram(this, z_norm, modes)
            % "Extrai" o tempo desejado (em regime permanente)
            [lin,~] = find(this.t_sol(:,1) >= GeneralOptions.SolOpt.permaTime(1) ...
                & this.t_sol(:,1) <= GeneralOptions.SolOpt.permaTime(2));
            begin = lin(1);
            finish = lin(size(lin,1));
            t_plot=this.t_sol(begin:finish); % new time vector
            
            % Matrix with coordinates
            mat = (this.x_sol(begin:finish,1)*modes(1,:)+this.x_sol(begin:finish,2)*modes(2,:)+this.x_sol(begin:finish,3)*modes(3,:))';
            
            % Open new tab
            thistab = uitab('Title','Scalogram','BackgroundColor', 'w'); 
            axes('Parent',thistab); % somewhere to plot
            
            % Plot data and change colors
            pcolor(t_plot, z_norm, mat)
            shading 'Interp'
            
            % Color bar plot
            cb = colorbar;
            cb.Label.String = 'u(z/L,\tau)/D';
            cb.Label.FontSize = this.FontSize;
            cb.Label.FontName = this.FontName;
            
            % Legends
            xlabel('\tau = t\omega_1', 'FontName', this.FontName, 'FontSize', this.FontSize)
            ylabel('z/L', 'FontName', this.FontName, 'FontSize', this.FontSize)
            set(gca, 'FontName', this.FontName, 'FontSize', this.FontSize)
            
        end
        
    end
end

