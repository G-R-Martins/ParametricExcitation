function [rom, fem] = AnalyzeROMs(rom, fem, shpFun)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

%     % Global struct
%     global beamData
    
%     % Window title
%     fig_titles = ["Beam in air" "Imersed beam"];

    for cont_rom = 1:size(rom,2)
        
        if isempty(rom{cont_rom}) == false
                        
            %% Solve the system of equations
            rom{cont_rom}.SolveSystemEqs(2,shpFun.modes);
            
            
%             %% Create tabular plot
%             rom{cont_rom}.OpenTabularPlot(fig_titles(cont_rom));
            
            
            %% Displacements
            for ii = 1:3
                rom{cont_rom}.CalculateResults(shpFun.modes, ii);
                rom{cont_rom}.CalculateSpectrum(ii);
%                 rom{cont_rom}.MultiTabPlot(ii);
            end
            
            
            %% Modal responses
            if rom{cont_rom}.mAmp.out_bools_A.show_A == true
                for ii = 1:3
                    % Calculate frequency spectrum
                    rom{cont_rom}.mAmp.CalculateSpectrum(rom{cont_rom}.t_sol, ...
                        rom{cont_rom}.x_sol(:,ii+3), ii);
%                     rom{cont_rom}.mAmp.MultiTabPlot(ii, ...
%                         rom{cont_rom}.t_sol, rom{cont_rom}.x_sol);
                end
            end % end if (plot A's)
            
            
%             %% Scalogram
%             if rom{cont_rom}.out_bools.scalogram == true
%                 rom{cont_rom}.PlotScalogram(shpFun.z/beamData.L, shpFun.modes);
%             end
            
        end % end if (empty or not)

    end
end
