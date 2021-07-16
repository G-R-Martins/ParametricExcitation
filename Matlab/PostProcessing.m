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
                end % end if (cell not empty)
                
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
                        Plots.AddLegend({'$A_1$','$A_2$','$A_3$'});
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
            
            % 1 - top
            % 2 - bottom
            for pos = 1:2
                if genOpt.plot_tensions(pos) == true
                    
                    figIsOpened = false;
                    
                    % Lacation of the tension
                    if pos == 1; legLoc = "-top"; else; legLoc = "-bottom"; end
                    
                    % Legend
                    leg = {};
%                     leg=cell(1,... legend
%                         sum(~cellfun(@isempty,rom))+sum(~cellfun(@isempty,fem)));
%                     legCont = 1; % count legend labels
                    
                    % 1 - air
                    % 2 - water
                    for env = 1:2
                        % Enviroment identification (for the legend)
                        if env == 1;  legEnv = "-air";
                        else;          legEnv = "-water";
                        end
                        
                        %-- Open a new figure
                        if ~figIsOpened && ~genOpt.plotTabs
                            
                            figName = strcat('Tensions-n=',num2str(n),...
                                legLoc);
                            fig = Plots.OpenFig(figName,...
                                Plots.defAxis('tau'),'Tension [N]',...
                                SolutionOpt.permaPlot);
                            
                            % Set boolean to true to avoid a new fig
                            figIsOpened = true;
                        end % end if (open figure)
                        
                        
                        % Check existing data to plot
                        if ~isempty(rom{env})
                            rom{env}.SetTensions(n,pos);
                            rom{env}.PlotTensions(pos);
                            %-- legend
                            leg{size(leg,2)+1} = strcat('ROM',legEnv);
                        end
                        if ~isempty(fem{env})
                            fem{env}.SetTensions(pos);
                            fem{env}.PlotTensions(pos);
                            %-- legend
                            leg{size(leg,2)+1} = strcat('FEM',legEnv);
                        end
                        
                        % Add legend
                        %-- multiple tabs  ||  after all data were plotted
                        if genOpt.plotTabs || env == 2
                            Plots.AddLegend(leg);
                        end
                        
                        % Save results
                        if env == 2 && ~genOpt.plotTabs &&  ...
                                ( genOpt.saveFigs == true || ...
                                rom{env}.out_bools.save_disp || ...
                                fem{env}.out_bools.save_disp )
                            
                            set(gcf,'PaperSize',Plots.default_paperSize);
                            print(fig, strcat(figDir,figName), ...
                                Plots.figFormat, Plots.figRes);
                        end
                        
                    end % end for (cases air/water)
                    
                end % end if (plot tensions)
            end % end for (top/bottom locations)
            
        end % function

    end % methods
end % class