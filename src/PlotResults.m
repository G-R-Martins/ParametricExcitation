function [] = PlotResults(rom, fem, shpFun, n)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

global beamData

% Window title
fig_titles = ["Beam in air" "Imersed beam"];

% 1 - air
% 2 - water
for cont = 1:2
    
    %% Checks exists data
    if ~isempty(rom{cont}) || ~isempty(fem{cont})
        
        %% Create tabular plot
        if ~isempty(rom{cont})
            rom{cont}.OpenTabularPlot(strcat(fig_titles(cont),' - n=',num2str(n)));
        else
            rom{cont}.OpenTabularPlot(strcat(fig_titles(cont),' - n=',num2str(n)));
        end
        
        %% Displacements
        
        % FEM e ROM
        if ~isempty(rom{cont}) && ~isempty(fem{cont})
            for cont_disp = 1:3
                rom{cont}.MultiTabPlot(cont_disp);
                % Check plot figure blocks (it depends on the presence of the phase space)
                if rom{cont}.out_bools.phaseSpace == true
                    n = 3;
                else
                    n = 2;
                end
                fem{cont}.MultiTabPlot(cont_disp, false, n);
            end
        % Only ROM data
        elseif ~isempty(rom{cont})
            for cont_disp = 1:3
                rom{cont}.MultiTabPlot(cont_disp);
            end
        % Only FEM data
        else 
            for cont_disp = 1:3
                fem{cont}.MultiTabPlot(cont_disp, false, 2);
            end
        end % end displacements
        
        
        %% Generalized modal coordinates 
        if ~isempty(rom{cont})
            if rom{cont}.genCoord.out_bools_A.show_A == true
                for ii = 1:3
                    rom{cont}.genCoord.MultiTabPlot(ii, ...
                        rom{cont}.t_sol, rom{cont}.x_sol);
                end
            end
            
            %% Scalogram
            if rom{cont}.out_bools.scalogram == true
                rom{cont}.PlotScalogram(shpFun.z/beamData.L, shpFun.modes);
            end
        end
        
    end % end if
    
end % end ROM's

end % end function

