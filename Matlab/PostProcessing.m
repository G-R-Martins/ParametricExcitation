classdef PostProcessing < Plots & handle
    
    
    methods (Static)
        
        function [] = PlotResults(rom, fem, shpFun, n, genOpt)
            
            global beamData
            
            %-- Window/Fig title
            figEnvType = ["Air" "Imersed"];
            figNodeLoc = ["25L" "50L" "75L"]; %Node location (% of the length)
            figDir = '..\figs\';
            
            %% Displacements, phase space and frequency spectrum
            
            % Create window to plot in multiple tabs
            if genOpt.plotTabs == true
                Plots.OpenTabularPlot(strcat('n=',num2str(n)));
            end
            
            % Iterate through the nodes
            for cont_disp = 1:3
                
                %%-- General results (displacements, freq, phase space)
                
                % FEM and ROM
                if sum(~cellfun(@isempty,rom)) > 0 || ...
                        sum(~cellfun(@isempty,fem)) > 0
                    
                    % separated plots
                    figIsOpened = false; 
                    
                    % 1 - air
                    % 2 - water
                    for cont = 1:2
                        
                        % Check existing data
                        if ~isempty(rom{cont}) && ~isempty(fem{cont})
                            
                            %-- Open a new figure
                            if figIsOpened == false && ...
                                genOpt.plotTabs == false
                                figName = strcat('n=',num2str(n),'-',...
                                    figNodeLoc(cont_disp));
                                fig = rom{cont}.OpenSiglePlotFig(figName);
                                
                                figIsOpened = true;
                            end
                            
                            %-- Plot results
                            rom{cont}.PlotResults(cont_disp,genOpt.plotTabs);
                            fem{cont}.PlotResults(cont_disp, false, ...
                                2 + rom{cont}.out_bools.phaseSpace);
                            
                            % Add legend for each tab
                            if genOpt.plotTabs
                                Plots.AddLegend({'ROM - air','FEM - air'});
                            end
                            
                        end %end for (air/water)
                    end % end for (air/water)
                end % end if (cell not empty)
                
                % Add legend
                if ~genOpt.plotTabs
                    Plots.AddLegend({'ROM - air','FEM - air',...
                                'ROM - water','FEM - water',});
                end
                
                % Save results
                if genOpt.saveFigs == true || ...
                        rom{cont}.out_bools.save_disp || ...
                        fem{cont}.out_bools.save_disp
                    set(gcf,'PaperSize',Plots.default_paperSize);
                    print(fig, strcat(figDir,figName), ...
                        Plots.figFormat, Plots.figRes);
                end
            end % end for (nodes)
            
            
            %% Generalized coordinates
            % 1 - air
            % 2 - water
            for cont = 1:2
                
                % Check existing data
                if ~isempty(rom{cont}) && ...
                        rom{cont}.genCoord.out_bools_A.show_A == true
                    %-- open a new figure
                    if genOpt.plotTabs == false
                        figName = strcat('n=',num2str(n),'-',...
                            figEnvType(cont),'-As');
                        fig = rom{cont}.OpenSiglePlotFig(figName);
                        
                    end
                    
                    %-- Plot results
                    for ii = 1:3
                        rom{cont}.genCoord.PlotResults(...
                            ii, genOpt.plotTabs, ...
                            rom{cont}.t_sol(rom{cont}.plot_range(1)...
                            :rom{cont}.plot_range(2)), ...
                            rom{cont}.x_sol(rom{cont}.plot_range(1)...
                            :rom{cont}.plot_range(2),:), ...
                            ~genOpt.plotTabs);
                    end % end for
                    
                    if ~genOpt.plotTabs
                        Plots.AddLegend({'A_1','A_2','A_3'});
                    end
                    
                    %-- Save results
                    if genOpt.saveFigs == true || ...
                            rom{cont}.genCoord.out_bools_A.save_Ak
                        set(gcf,'PaperSize',Plots.default_paperSize);
                        print(fig, strcat(figDir,figName), ...
                            Plots.figFormat, Plots.figRes);
                    end
                end % end if (show fig)
                
                %% Scalogram
                % ROM
                if ~isempty(rom{cont}) && ...
                        rom{cont}.out_bools.scalogram == true
                    %-- open a new figure
                    if genOpt.plotTabs == false
                        figName = strcat('n=',num2str(n),'-',...
                            figEnvType(cont),'-Scalogram-ROM');
                        fig = rom{cont}.OpenSiglePlotFig(figName);
                    end
                    
                    %-- plot the scalogram
                    rom{cont}.PlotScalogram(genOpt.plotTabs, ...
                        shpFun.z/beamData.L, shpFun.modes);
                    
                    %-- Save results
                    if genOpt.saveFigs == true || ...
                            rom{cont}.out_bools.save_disp
                        set(gcf,'PaperSize',Plots.default_paperSize);
                        print(fig, strcat(figDir,figName), ...
                            Plots.figFormat, Plots.figRes);
                    end
                end % end if (ROM scalogram)
                
                % FEM 
                if ~isempty(fem{cont}) && ...
                        fem{cont}.out_bools.plot_scalogram == true
                    %-- open a new figure
                    if genOpt.plotTabs == false
                        figName = strcat('n=',num2str(n),'-',...
                            figEnvType(cont),'-Scalogram-FEM');
                        fig = fem{cont}.OpenSiglePlotFig(figName);
                    end
                    
                    %-- plot the scalogram
                    fem{cont}.PlotScalogram(genOpt.plotTabs);
                    
                    %-- Save results
                    if genOpt.saveFigs == true || ...
                            fem{cont}.out_bools.save_scalogram == true
                        set(gcf,'PaperSize',Plots.default_paperSize);
                        print(fig, strcat(figDir,figName), ...
                            Plots.figFormat, Plots.figRes);
                    end
                end % end if (FEM scalogram)
                
            end % end for (air/water)
            
            %% Tensions
            if genOpt.plot_tensions == true
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
                        Plots.OpenFig(figname,'\tau = t\omega_1','Tension [N]',...
                            SolutionOpt.permaPlot);
                        
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