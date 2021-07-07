classdef PostProcessing < Plots & handle
     
    
    methods (Static)
        
        function [] = PlotResults(rom, fem, shpFun, n, show_tensions, ...
                boolTab, saveAll)
            
            global beamData
            
            %-- Window title
            fig_titles = ["Air" "Imersed"];
            
            default_paperSize = [3.5 6];
            figFormat = '-dpng';
            
            % 1 - air
            % 2 - water
            for cont = 1:2
                
                %% Check existing data
                if ~isempty(rom{cont}) || ~isempty(fem{cont})
                    
                    %% Create tabular plot
                    if boolTab == true
                        if ~isempty(rom{cont})
                            rom{cont}.OpenTabularPlot(strcat(...
                                fig_titles(cont),'-n=',num2str(n)));
                        else
                            fem{cont}.OpenTabularPlot(strcat(...
                                fig_titles(cont),'-n=',num2str(n)));
                        end
                    end
                    
                    %% General results (displacements, freq, phase space)
                    
                    % FEM and ROM
                    if ~isempty(rom) && sum(~cellfun(@isempty,fem))
                        for cont_disp = 1:3
                            %-- open a new figure
                            if boolTab == false
                                nomeFig = strcat(fig_titles(cont),...
                                    '_n=',num2str(n),"_",...
                                    rom{cont}.titles(cont_disp));
                                rom{cont}.OpenSiglePlotFig(nomeFig);
                            end          
                            
                            %-- Plot results
                            rom{cont}.PlotResults(cont_disp, boolTab);
                            fem{cont}.PlotResults(cont_disp, false, ...
                                2 + rom{cont}.out_bools.phaseSpace);
                            %-- Save results
                            if saveAll == true || ...
                                    rom{cont}.out_bools.save_disp || ...
                                    fem{cont}.out_bools.save_disp
                                disp('print ROM and FEM')
                                set(gcf,'PaperSize',default_paperSize);
                                print(nomeFig, figFormat, '-r1000')
                            end
                        end % end for
                        
                    % Only ROM data
                    elseif ~isempty(rom{cont})
                        for cont_disp = 1:3
                            %-- open a new figure
                            if boolTab == false
                                nomeFig = strcat(fig_titles(cont),...
                                    '-n=',num2str(n),"-",...
                                    rom{cont}.titles(cont_disp));
                                fig = rom{cont}.OpenSiglePlotFig(nomeFig);
                            end
                            %-- Plot results
                            rom{cont}.PlotResults(cont_disp, boolTab, fig);
                            
                            %-- Save results
                            if saveAll == true || rom{cont}.out_bools.save_disp
                                disp('print ROM')
                                set(gcf,'PaperSize',default_paperSize);
                                print(nomeFig, figFormat, '-r1000')
                            end
                        end % end for
                        
                    % Only FEM data
                    else
                        for cont_disp = 1:3
                            %-- open a new figure
                            if boolTab == false
                                nomeFig = strcat(fig_titles(cont),...
                                    '-n=',num2str(n),"-",...
                                    fem{cont}.titles(cont_disp));
                            fem{cont}.OpenSiglePlotFig(nomeFig);
                            end
                            %-- Plot results
                            fem{cont}.PlotResults(cont_disp, false, 2);
                            
                            %-- Save results
                            if saveAll == true || fem{cont}.out_bools.save_disp
                                disp('print FEM')
                                set(gcf,'PaperSize',default_paperSize);
                                print(nomeFig, figFormat, '-r1000')
                            end
                        end % end for
                        
                    end % end general results
                    
                    
                    
                    %% Generalized coordinates
                    if ~isempty(rom{cont}) && ...
                            rom{cont}.genCoord.out_bools_A.show_A == true
                        for ii = 1:3
                            %-- open a new figure
                            if boolTab == false
                                strcat(fig_titles(cont),'-n=',...
                                    num2str(n),"-A",num2str(ii));
                                rom{cont}.OpenSiglePlotFig(nomeFig);
                            end
                            rom{cont}.genCoord.PlotResults(...
                                ii, boolTab, ...
                                rom{cont}.t_sol(rom{cont}.plot_range(1)...
                                :rom{cont}.plot_range(2)), ...
                                rom{cont}.x_sol(rom{cont}.plot_range(1)...
                                :rom{cont}.plot_range(2),:)...
                                );
                            %-- Save results
                            if saveAll == true || ...
                                    rom{cont}.genCoord.out_bools_A.save_Ak
                                disp('print A_k')
                                set(gcf,'PaperSize',default_paperSize);
                                print(nomeFig, figFormat, '-r1000')
                            end
                        end % end for
                    end % end if (show fig)
                    
                    %% Scalogram
                    if ~isempty(rom{cont}) && ...
                            rom{cont}.out_bools.scalogram == true
                        %-- open a new figure
                        if boolTab == false
                            nomeFig = strcat(fig_titles(cont),'-n=',...
                                num2str(n),"-Scalogram",num2str(ii));
                            rom{cont}.OpenSiglePlotFig(nomeFig);
                        end
                        rom{cont}.PlotScalogram(boolTab, ...
                            shpFun.z/beamData.L, shpFun.modes);
                        
                        %-- Save results
                        if saveAll == true || rom{cont}.out_bools.save_disp
                            disp('print ROM')
                            set(gcf,'PaperSize',default_paperSize);
                            print(nomeFig, figFormat, '-r1000')
                        end
                    end % end if (scalogram)
                    
                    
                end % end if (cell not empty)
                
            end % end ROM's
            
            %% Tensions
            if show_tensions == true
                
                % 1 - air
                % 2 - water
                for cont = 1:2
                    if ~isempty(rom{cont}) || ~isempty(fem{cont})
                        if cont == 1
                            figname = strcat('Tensions-n=',num2str(n),...
                                "-air");
                        else
                            figname = strcat('Tensions-n=',num2str(n),...
                                "-water");
                        end
                        Plots.OpenFig(figname,'Time [s]','Tension [N]',...
                            [1000 1005],...%GeneralOptions.SolOpt.permaPlot, ...
                            Plots.FontName, Plots.FontSize);
                        
                    end
                    
                    %% Check existing data
%                     leg={};
                    if ~isempty(rom{cont})
                        rom{cont}.SetTensions(n);
                        rom{cont}.PlotTensions();
%                         leg{1}= 'Rom'; 
                    end
                    if ~isempty(fem{cont})
                        fem{cont}.SetTensions();
                        fem{cont}.PlotTensions();
%                         leg{size(leg,2)+1}='FEM';
                    end
                    
                    %-- legend
%                     legend(leg,'FontName', this.FontName, 'FontSize', ...
%                         this.FontSizeLegend, 'Location', 'southwest');
                    
                end % end for (cases air/water)
                
            end % end if
            
            
            
        end % function
        
    end % methods
    
end % class