classdef Analysis
    %ANALYSIS Summary of this class goes here
    %   Detailed explanation goes here
    
    
    methods (Static)
        
        %% Evalute amplitude spectrum
        function [freq, Amp, fd, Ad] = Spectrum(t, signal)
            %-- Header
            % Inputs  - t -> vector with time discretization
            %           signal -> vector with data signal
            % Outputs - freq -> vector with frequency data
            %         - Amp  -> vector with amplitude data
            %         - fd   -> dominant frequency
            %         - Ad   -> amplitude of the dominant frequency
            
            %-- Function
            N = length(t);
            deltat = t(2)-t(1);
            fs = 1/deltat;
            freq = [0:N-1]*fs/N;
            Xs = fft(signal);
            Amp = abs(Xs)/N;
            Amp = 2*Amp(1:fix(N/2));
            [Ad,index]= max(Amp);
            
            % Normalize with first mode frequency
            freq = freq(1:fix(N/2))*2*pi;
            
            fd = freq(index);
        end
        

        %%  ROM data analysis
        function rom = ROMs(rom, shpFun, n)
            
            for cont_rom = 1:size(rom,2)
                
                if isempty(rom{cont_rom}) == false
                    
                    
                    %% Solve the ROM`s system of equations
                    rom{cont_rom}.SolveSystemEqs(n,shpFun.modes);
                    
                    
                    %% 
                    rom{cont_rom}.SetPermanentRange();
                    
                    
                    %% ROM - Displacements
                    for ii = 1:3
                        rom{cont_rom}.CalculateResults(shpFun.modes, ii);
%                         rom{cont_rom}.CalculateSpectrum(ii);
                        [rom{cont_rom}.Freq{ii}, rom{cont_rom}.Ampl{ii},...
                            rom{cont_rom}.Fd(ii), rom{cont_rom}.Ad(ii)] =...
                            Analysis.Spectrum(rom{cont_rom}.t_sol, rom{cont_rom}.U{ii});
                    end
                    
                    
                    %% ROM - Modal responses
                    if rom{cont_rom}.genCoord.out_bools_A.show_A == true
                        for ii = 1:3
                            % Calculate frequency spectrum
                            [rom{cont_rom}.genCoord.freq_A_k{ii}, ...
                                rom{cont_rom}.genCoord.ampl_A_k{ii},...
                                rom{cont_rom}.genCoord.Fd_A_k(ii), ...
                                rom{cont_rom}.genCoord.Ad_A_k(ii)] =...
                                Analysis.Spectrum(rom{cont_rom}.t_sol, ...
                                rom{cont_rom}.x_sol(:,ii+3));
                        end
                    end % end if (plot A's)
                    
                    
                end % end if (empty or not)
            end % end for ('rom' objects)
        end
        
        
        %% FEM data analysis
        function fem = FEMs(fem)
            
            % Iterates through fem objects
            for cont_rom = 1:size(fem,2)
                
                if isempty(fem{cont_rom}) == false
                    % Displacements
                    init=3703;
                    for ii = 1:3
%                         fem{cont_rom}.CalculateSpectrum(ii);
                        [fem{cont_rom}.Freq{ii}, fem{cont_rom}.Ampl{ii},...
                            fem{cont_rom}.Fd(ii), fem{cont_rom}.Ad(ii)] =...
                            Analysis.Spectrum(fem{cont_rom}.time(init:size(fem{cont_rom}.time,1),1),...
                            fem{cont_rom}.U{ii}(init:size(fem{cont_rom}.time,1)));
                    end
                end 
                
            end % end for('fem' objects)
        end % end function
        
    end % end Methods
end

