function [shpFun, rom, fem] = SetModel(gOpt, n)

    % Global struct with common parameters for beams (immersed and in air)
    global beamData
    
    %% ROM
    rom = cell(1,2);
    %-- immersed
    if gOpt.include_ROM_water == true
        rom{2} = ROM(0.112982,true, gOpt.ROM_freq_water(n), 33.4405);
        rom{2}.SetOutputOptions(...
            0, ... displacement time series
            0, ... scalogram
            0, ... tension
            1, ... show phaseSpace
            1  ... show scalogram
        );
        rom{2}.genCoord.SetOutputOptions(...
            1, ... show A
            0, ... show maximum Ak
            0, ... show amplitude of A
            0, ... save A
            0, ... save Ak
            0, ... save amplitude of A
            1  ... show phase space
            );
    end
    %-- air
    if gOpt.include_ROM_air == true
        rom{1} = ROM(0.130464, false, gOpt.ROM_freq_air(n), 38.40686);
        rom{1}.SetOutputOptions(...
            0, ... displacement time series
            0, ... scalogram
            0, ... tension
            1, ... show phaseSpace
            1  ... show scalogram
        );
        rom{1}.genCoord.SetOutputOptions(...
            1, ... show A
            0, ... show maximum Ak
            0, ... show amplitude of A
            0, ... save A
            0, ... save Ak
            0, ... save amplitude of A
            1  ... show phase space
            );
    end
    
    %% FEM
    fem = cell(1,2); %return null cell if any data is readed
    
    % Scalogram only for n=4 (next I'll upload data for other excitations)
    if n ==  4; scalog = true; else; scalog = false; end
    
    % Initialize fem objects
    if ismember(n, gOpt.SolOpt.n_plot)
        FEM_dir = strcat(FEM.data_dir,'n=',num2str(n),'\');
        % immersed
        if gOpt.include_FEM_water == true
            fem{2} = FEM(true, strcat(FEM_dir,'water\'), ...
                gOpt.FEM_freq_water(n),0.02, 5);
            fem{2}.SetOutputOptions(...
                0, ... displacement
                0, ... tension
                0, ... save scalogram
                scalog  ... plot scalogram
                );
        end
        % air
        if gOpt.include_FEM_air == true
            fem{1} = FEM(false,strcat(FEM_dir,'air\'),gOpt.FEM_freq_air(n),...
                0.02, 5); % timestep, sample
            fem{1}.SetOutputOptions(...
                0, ... displacement
                0, ... tension
                0, ... save scalogram
                scalog  ... plot scalogram 
                );
        end
    end
    
    %% Shape functions
    shpFun = ShapeFunctions(beamData.L,3,false);
    
    %%% TODO - Retirar dessa função
    if shpFun.print_modes == true
        shpFun.SinglePlot([],"Shape Functions");
    end
    
    %% Set 'coef'
    for cont = 1:size(rom,2)
        if ~isempty(rom{cont})
            if rom{cont}.isImmersed == true
                rom{cont}.mor_coef = rom{2}.L_m * (shpFun.z(2)-shpFun.z(1));
            else
                rom{cont}.mor_coef = 0;
            end
        end
    end % end for
end

