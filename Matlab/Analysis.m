classdef Analysis
    %ANALYSIS Summary of this class goes here
    %   Detailed explanation goes here
    
    
    methods (Static)
        
%         function [freq, Amp, fd, Ad] = Spectrum(t, signal)
%
%         end
        

        %%  ROM data analysis
        function rom = ROMs(rom, shpFun, n)
            
            for cont_rom = 1:size(rom,2)
                
                if isempty(rom{cont_rom}) == false
                    
                    %% Solve the ROM`s system of equations
                    rom{cont_rom}.SolveSystemEqs(n,shpFun.modes);
                    
                    
                    %% ROM - Displacements
                    for ii = 1:3
                        rom{cont_rom}.CalculateResults(shpFun.modes, ii);
                        rom{cont_rom}.CalculateSpectrum(ii);
                    end
                    
                    
                    %% ROM - Modal responses
                    if rom{cont_rom}.genCoord.out_bools_A.show_A == true
                        for ii = 1:3
                            % Calculate frequency spectrum
                            rom{cont_rom}.genCoord.CalculateSpectrum(rom{cont_rom}.t_sol, ...
                                rom{cont_rom}.x_sol(:,ii+3), ii);
                        end
                    end % end if (plot A's)
                    
                end % end if (empty or not)
                
            end % end for (`rom` objects`)
        end
        
        
        %% FEM data analysis
        function fem = FEMs(fem)
            
            % Iterates through fem objects
            for cont_rom = 1:size(fem,2)
                
                if isempty(fem{cont_rom}) == false
                    % Displacements
                    for ii = 1:3
                        fem{cont_rom}.CalculateSpectrum(ii);
                    end
                end 
                
            end % end for(`fem` objects)
            
        end % end function
        
    end % end Methods
end

