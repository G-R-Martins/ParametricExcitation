classdef ROM < Plots & handle
    %% ROM Summary 
    
    
    %% Properties
       
    % Values dependent on water immersion
    properties (SetAccess = public, GetAccess = public)
        
        % Immersed? 
        isImmersed (1,1) logical
        
        Tt       (1,1) double
        f1       (1,1) double
        w1       (1,1) double
        
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
        
        % Tension time series
        Tension_top double
        Tension_bottom double
        
        % First row with data to consider as permanent regime
        permaRegInit (1,1) double
        
        % Range to plot time series
        plot_range double
    end
    
    properties (Constant)
        titles = ["u(L/4)" "u(L/2)" "u(3L/4)"];
        labels = struct('u',["$u (L/4,\tau)/D $" "$ u(L/2,\tau)/D $" "$ u(3L/4,\tau)/D $"],...
            'du',["$ u'(L/4,\tau)/D $" "$ u'(L/2,\tau)/D $" "$ u'(3L/4,\tau)/D $"]);
        
    end
    
    properties
        genCoord GenModalCoord
    end
    
    %% Methods
    
    methods 
        
        %% Constructor
        function this = ROM(c, bool_immersed, f, Tt)
            global beamData
            
            % Initialize empty cells
            this.U{3} = {};    % displacement
            this.V{3} = {};    % velocities
            this.Freq{3} = {}; % frequency
            this.Ampl{3} = {}; % amplitude
            
            % Initialize modal amplitude object
            this.genCoord = GenModalCoord();
            
            this.c = c;
            this.isImmersed = bool_immersed;
            
            this.f1 = f; % First mode frequency
            this.Tt = Tt; % Static top tension
                
            if bool_immersed == false
                this.mu_a = 0;
                this.Cd = 0;
                this.gamma = beamData.mu * Environment.grav;
            else
                this.mu_a = beamData.mu_d; % to get Ca=1
                this.Cd = 1.2; 
                this.gamma = beamData.mu * Environment.grav ...
                    - Environment.rho*Environment.grav*pi*beamData.d^2/4;
            end
            
            this.w1 = 2*pi*this.f1; % First mode frequency (rad/s)
            
            % Nondimensional quantities
            
            this.Ca = this.mu_a/beamData.mu_d;
            
            %-- Lambda_M (Morison)
            this.L_m = beamData.d^2/(beamData.L*beamData.mu_d*(beamData.m+this.Ca))*Environment.rho*this.Cd;
            
            %-- Alphas
            this.a = [this.c/(beamData.mu_d*(beamData.m+this.Ca)*this.w1) ...
                -40*this.gamma/(9*beamData.mu_d*(beamData.m+this.Ca)*this.w1^2*beamData.L) ...
                beamData.d^2*beamData.EA/(4*beamData.mu_d*(beamData.m+this.Ca)*this.w1^2)*(pi/beamData.L)^4 ...
                beamData.d^2*beamData.EA/(beamData.mu_d*(beamData.m+this.Ca)*this.w1^2)*(pi/beamData.L)^4 ...
                9*beamData.d^2*beamData.EA/(4*beamData.mu_d*(beamData.m+this.Ca)*this.w1^2)*(pi/beamData.L)^4];
            
            %-- Betas
            this.b = [this.a(1) ...
                -312*this.gamma/(25*beamData.mu_d*(beamData.m+this.Ca)*this.w1^2*beamData.L) ...
                this.a(2) ...
                this.a(4) ...
                beamData.d^2*beamData.EA/(4*beamData.mu_d*(beamData.m+this.Ca)*this.w1^2)*(2*pi/beamData.L)^4 ...
                9*beamData.d^2*beamData.EA/(beamData.mu_d*(beamData.m+this.Ca)*this.w1^2)*(pi/beamData.L)^4];
            
            %-- Gammas
            this.g = [this.a(1)
                this.b(2)
                this.b(6)
                this.a(5)
                beamData.d^2*beamData.EA/(4*beamData.mu_d*(beamData.m+this.Ca)*this.w1^2)*(3*pi/beamData.L)^4];
            
            %-- Epsilons
            this.ep = [(beamData.EA/beamData.L)*(pi/beamData.L)^2*(beamData.At/(beamData.mu_d*(beamData.m+this.Ca)*this.w1^2)) ...
                (beamData.EA/beamData.L)*((2*pi)/beamData.L)^2*(beamData.At/(beamData.mu_d*(beamData.m+this.Ca)*this.w1^2)) ...
                (beamData.EA/beamData.L)*((3*pi)/beamData.L)^2*(beamData.At/(beamData.mu_d*(beamData.m+this.Ca)*this.w1^2))];
            
            %-- Deltas
            this.d = [(beamData.EI/(beamData.mu_d*(beamData.m+this.Ca)*this.w1^2))*(pi/beamData.L)^4-(1/2)*((this.gamma*beamData.L)/(beamData.mu_d*(beamData.m+this.Ca)*this.w1^2))*(pi/beamData.L)^2+(pi/beamData.L)^2*(this.Tt/(beamData.mu_d*(beamData.m+this.Ca)*this.w1^2)) ...
                (beamData.EI/(beamData.mu_d*(beamData.m+this.Ca)*this.w1^2))*(2*pi/beamData.L)^4-(1/2)*((this.gamma*beamData.L)/(beamData.mu_d*(beamData.m+this.Ca)*this.w1^2))*(2*pi/beamData.L)^2+(2*pi/beamData.L)^2*(this.Tt/(beamData.mu_d*(beamData.m+this.Ca)*this.w1^2)) ...
                (beamData.EI/(beamData.mu_d*(beamData.m+this.Ca)*this.w1^2))*(3*pi/beamData.L)^4-(1/2)*((this.gamma*beamData.L)/(beamData.mu_d*(beamData.m+this.Ca)*this.w1^2))*(3*pi/beamData.L)^2+(3*pi/beamData.L)^2*(this.Tt/(beamData.mu_d*(beamData.m+this.Ca)*this.w1^2))];            
        
        end
        
        
        %%=== Functions ===%%
        
        %% Setting plot/save options
        function SetOutputOptions(this, save_disp, save_scalogram,...
                save_tension, show_phaseSpace, show_scalogram)
            % Saving options
            this.out_bools.save_disp = save_disp;
            this.out_bools.save_scalogram = save_scalogram;
            this.out_bools.save_tension = save_tension;
            
            % Plot options
            this.out_bools.phaseSpace = show_phaseSpace;
            this.out_bools.scalogram = show_scalogram;
        end
        
        
        %% Evaluate displacements and velocities
        function CalculateResults(this, modes, k)
			sz = size(modes,2)*k/4;
            this.U{k} = this.x_sol(:,1)*modes(1,sz) + ...
                this.x_sol(:,2)*modes(2,sz) + this.x_sol(:,3)*modes(3,sz);
            this.V{k} = this.x_sol(:,1+3)*modes(1,sz) + ...
                this.x_sol(:,2+3)*modes(2,sz) + this.x_sol(:,3+3)*modes(3,sz);
        end
        
        
        %% Solve the system equations
        function SolveSystemEqs(this, n, modes)
            t = GeneralOptions.SolOpt.ti:GeneralOptions.SolOpt.dt:GeneralOptions.SolOpt.tf;
            f = @(t,x) this.Integrator(t, x, n, modes);
            [this.t_sol, this.x_sol] = ode45(f, t, GeneralOptions.SolOpt.x0);
        end
        
        
        %% Integrate equations of motion
        function y = Integrator(this,t,x,n, modes)
            
            % Initialize matrix to put results
            y = zeros(6,1);
            
            % Velocities
            y(1,1)=x(4,1);
            y(2,1)=x(5,1);
            y(3,1)=x(6,1);
            
            % Acelerations
            y(4,1)=-this.a(1)*x(4,1) - (this.d(1)+this.ep(1)*sin(n*t))*x(1,1) ...
                -this.a(2)*x(2,1) - this.a(3)*x(1,1)^3 ...
                - this.a(4)*x(1,1)*x(2,1)^2 - this.a(5)*x(1,1)*x(3,1)^2 ...
                -this.mor_coef*(modes(1,:)*((x(4,1)*modes(1,:)+...
                x(5,1)*modes(2,:)+x(6,1)*modes(3,:)).*abs(x(4,1)*modes(1,:)...
                +x(5,1)*modes(2,:)+x(6,1)*modes(3,:)))');
            
            y(5,1)=-this.b(1)*x(5,1) - (this.d(2)+this.ep(2)*sin(n*t))*x(2,1)...
                -this.b(2)*x(3,1) - this.b(3)*x(1,1) - this.b(4)*x(2,1)*x(1,1)^2 ...
                - this.b(5)*x(2,1)^3-this.b(6)*x(2,1)*x(3,1)^2 ...
                -this.mor_coef*(modes(2,:)*((x(4,1)*modes(1,:)+...
                x(5,1)*modes(2,:)+x(6,1)*modes(3,:)).*abs(x(4,1)*modes(1,:)...
                +x(5,1)*modes(2,:)+x(6,1)*modes(3,:)))');
            
            y(6,1)=-this.g(1)*x(6,1) - (this.d(3)+this.ep(3)*sin(n*t))*x(3,1)...
                -this.g(2)*x(2,1) - this.g(3)*x(3,1)*x(2,1)^2 ...
                - this.g(4)*x(3,1)*x(1,1)^2 - this.g(5)*x(3,1)^3 ...
                -this.mor_coef*(modes(3,:)*((x(4,1)*modes(1,:)+...
                x(5,1)*modes(2,:)+x(6,1)*modes(3,:)).*abs(x(4,1)*modes(1,:)...
                +x(5,1)*modes(2,:)+x(6,1)*modes(3,:)))');
            
        end
        
        %% Set permanent regime range
        function SetPermanentRange(this)
            
            % Begin of permanent regime (to evaluate spectrum)
            [id,~] = find(this.t_sol >= GeneralOptions.SolOpt.permaTime(1));

            % Delete transient data
            this.t_sol(1:id(1)-1) = [];
            this.x_sol(1:id(1)-1,:) = [];
            
            % Plot range (end)
            [id,~] = find(this.t_sol >= ...
                GeneralOptions.SolOpt.permaPlot(1) & ...
                this.t_sol <= GeneralOptions.SolOpt.permaPlot(2));
            
            this.plot_range = [id(1), id(size(id,1))];
            
        end
        
        
        %% Tension
        function SetTensions(this, n, loc)
            global beamData
            if loc == 1
                this.Tension_top = this.Tt - this.gamma * beamData.L +...            
                this.gamma*beamData.L +beamData.EA/beamData.L*beamData.At...
                * sin(n*this.t_sol);
            elseif loc == 2
                this.Tension_bottom = this.Tt - this.gamma * beamData.L +...            
                + beamData.EA/beamData.L*beamData.At...
                * sin(n*this.t_sol);
            else
                error("invalid option to set tension. It MUST be 1 (top) or 2 (bottom)")
            end
        end
        
        
        %% Bottom/Top tensions
        function PlotTensions(this, loc)
            if loc == 1
                plot(this.t_sol, this.Tension_top, ...
                    this.lines(loc,... default line
                        1+2*this.isImmersed)); % black
            elseif loc == 2
                plot(this.t_sol, this.Tension_bottom, ...
                    this.lines(loc+1,... dot dashed
                        1+2*this.isImmersed)); % dark orange (?)
            else
                error("Invalid option to plot tension. It MUST be 1 (top) or 2 (bottom)");
            end
        end
        
        
        %% Plot in multiple tabs
        function PlotResults(this, k, open_tab)
            
            % Open new tab
            if open_tab == true
                thistab = uitab('Title',this.titles(k),'BackgroundColor', 'w'); % build iith tab
                axes('Parent',thistab); % somewhere to plot
            end
            
            
            if this.out_bools.phaseSpace == true
                %-- Displacement time series
                subplot(2,2,2)
                hold on; box on;
                set(gca, 'fontsize', this.FontSize, ...
                    'xlim', GeneralOptions.SolOpt.permaPlot,...
                    'TickLabelInterpreter',Plots.interpreter)
                xlabel(Plots.defAxis('tau'),'FontName',this.FontName,...
                    'FontSize',this.FontSize,'Interpreter',Plots.interpreter)
                ylabel(this.labels.u(k),'FontName',this.FontName,...
                    'FontSize',this.FontSize,'Interpreter',Plots.interpreter)
                
                plot(this.t_sol, this.U{k},this.lines(1,1+2*this.isImmersed))
                
                
                %-- Frequency spectrum
                subplot(2,2,4)
                hold on; box on;
                set(gca, 'FontName',this.FontName, 'FontSize',this.FontSize, ...
                    'xlim', this.lim_plot_freq,'TickLabelInterpreter',Plots.interpreter)
                xlabel(Plots.defAxis('f'), 'FontName', this.FontName, ...
                    'FontSize',this.FontSize,'Interpreter',Plots.interpreter)
                ylabel('$S_{\hat{u}}(f)$', 'FontName', this.FontName, ...
                    'FontSize',this.FontSize, 'Interpreter',Plots.interpreter)
                
                plot(this.Freq{k}, this.Ampl{k},this.lines(1,1+2*this.isImmersed))
                
                %-- Phase space
                subplot(2,2,[1 3])
                hold on; box on;
                set(gca, 'FontName',this.FontName, 'FontSize',this.FontSize,...
                    'TickLabelInterpreter',Plots.interpreter)
                xlabel(this.labels.u(k), 'FontName', this.FontName, ...
                    'FontSize',this.FontSize, 'Interpreter',Plots.interpreter)
                ylabel(this.labels.du(k), 'FontName', this.FontName, ...
                    'FontSize',this.FontSize, 'Interpreter',Plots.interpreter)
                
                plot(this.U{k}(this.plot_range(1):this.plot_range(2),1),...
                    this.V{k}(this.plot_range(1):this.plot_range(2),1),...
                    this.lines(1,1+2*this.isImmersed));
                
             else
                 %-- Displacement time series
                 subplot(2,1,1)
                 hold on; box on;
                 set(gca, 'FontName',this.FontName, 'FontSize',this.FontSize, ...
                     'xlim', GeneralOptions.SolOpt.permaPlot,...
                     'TickLabelInterpreter',Plots.interpreter);
                 xlabel(Plots.defAxis('tau'), 'FontName', this.FontName, ...
                     'FontSize',this.FontSize,'Interpreter',Plots.interpreter);
                 ylabel(this.labels.u(k),'FontName', this.FontName, ...
                     'FontSize',this.FontSize,'Interpreter',Plots.interpreter);
                 
                 plot(this.t_sol, this.U{k}, this.lines(1,1+2*this.isImmersed));
                 
                 
                 %-- Frequency spectrum
                 subplot(2,1,2)
                 hold on; box on;
                 set(gca, 'FontName',this.FontName, 'FontSize',this.FontSize, ...
                     'xlim',this.lim_plot_freq,'TickLabelInterpreter',Plots.interpreter)
                 xlabel(Plots.defAxis('f'), 'FontName', this.FontName, ...
                     'FontSize',this.FontSize, 'Interpreter',Plots.interpreter)
                 ylabel('$S_{\hat{u}}(f)$', 'FontName', this.FontName,...
                     'FontSize',this.FontSize, 'Interpreter',Plots.interpreter)
                 
                 plot(this.Freq{k}, this.Ampl{k}, this.lines(1,1+2*this.isImmersed))
            end
            
            
        end % end function (PlotResults)
        
             
        
        %% Plot scalogram
        function PlotScalogram(this, open_tab, z_norm, modes)
            
            dTau = (this.t_sol(this.plot_range(2)) - ...
                this.t_sol(this.plot_range(1)) );
            
            % range to plot
            %try to get a simmetric range equivalent to 10*plot_range
            
            %-- end time -> ensure that a valid data is plotted
            plotFinish = min([...
                this.t_sol(this.plot_range(2)) + 2*dTau, SolutionOpt.tf]);
            plotBegin = this.t_sol(this.plot_range(1)) - 2*dTau;
            
            %-- Min/Max index
            [id,~] = find(this.t_sol >= plotBegin & ...
                this.t_sol <= plotFinish);
            
            begin = id(1);
            finish= id(size(id,1));
            
            mat = (this.x_sol(begin:finish,1)*modes(1,:)+...
                this.x_sol(begin:finish,2)*modes(2,:)+...
                this.x_sol(begin:finish,3)*modes(3,:))';
            
            % Open new tab
            if open_tab == true
                if this.isImmersed; tabName = 'Scalogram-rom-water';
                else;               tabName = 'Scalogram-rom-air';  end
                
                thistab = uitab('Title',tabName,'BackgroundColor','w');
                axes('Parent',thistab); % somewhere to plot
            end
            
            % Plot data and change colors
            pcolor(this.t_sol(begin:finish), z_norm, mat)
            shading 'Interp'
            
            % Color bar plot
            cb = colorbar;
            cb.Label.String = '$ u(z/L,\tau)/D $';
            cb.Label.FontSize = this.FontSize;
            cb.Label.FontName = this.FontName;
            cb.Label.Interpreter = Plots.interpreter;
            set(cb,'TickLabelInterpreter',Plots.interpreter);
            
            colormap jet
            
            % Labels
            set(gca, 'FontName', this.FontName, 'FontSize', this.FontSize,...
                'xlim',[4960 5060],'TickLabelInterpreter',Plots.interpreter)
            xlabel(Plots.defAxis('tau'), 'FontName', this.FontName, ...
                'FontSize',this.FontSize,'Interpreter',Plots.interpreter)
            ylabel(Plots.defAxis('z'), 'FontName',this.FontName, ...
                'FontSize',this.FontSize, 'Interpreter',Plots.interpreter)
            
        end
        
    end
end

