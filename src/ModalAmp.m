classdef ModalAmp < Plots
    %% Modal amplitude 
    %   Detailed explanation goes here
    
    properties
        n_modes (1,1) = 3;
        sin_args 
        z 
        modes 
        print_modes logical = false
    end
    
    
    properties (GetAccess = protected, SetAccess = private)
        save_respAmpli (1,1) logical = false;  % Resposta total
        save_respAmpli_Ak (1,1) logical = false; % Respostas modais
    end
    
    methods
        
        %% Constructor
        function this = ModalAmp(L, disc, n_modes) 
            % Arguments of sinusoidal shape functions 
            this.sin_args = [pi/L*L/4 pi/L*L/2 pi/L*3*L/4];
            
            % Vertical discretization
            z = linspace(0,L,disc);
            
%             % Non-dimensional including the time step (used to solve ODE's)
%             retang_nonDim = L_m*(z(2)-z(1));
            
            % Setting modes (shape functions)
            this.n_modes = n_modes;
            this.modes = zeros(n_modes,size(z,2));
            for ii = 1:1:n_modes
                this.modes(ii,:) = sin(ii*pi/L*z);
            end
            
            
        end
        
    end
end

