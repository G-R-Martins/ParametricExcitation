function [] = PlotResults(rom, shpFun)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

    global beamData
    
    % Window title
    fig_titles = ["Beam in air" "Imersed beam"];

    for cont_rom = 1:size(rom,2)
        
        % Checks if cell is empty 
        if isempty(rom{cont_rom}) == false    
            %% Create tabular plot
            rom{cont_rom}.OpenTabularPlot(fig_titles(cont_rom));
            
            %% Displacements
            for cont = 1:3
                rom{cont_rom}.MultiTabPlot(cont);
            end % end for
            
            %% Modal responses
                if rom{cont_rom}.mAmp.out_bools_A.show_A == true
                    for ii = 1:3
                        rom{cont_rom}.mAmp.MultiTabPlot(ii, ...
                            rom{cont_rom}.t_sol, rom{cont_rom}.x_sol);
                    end
                end
            
            %% Scalogram
            if rom{cont_rom}.out_bools.scalogram == true
                rom{cont_rom}.PlotScalogram(shpFun.z/beamData.L, shpFun.modes);
            end
            
        end % end if
        
    end % end ROM's
end

