function [gOpt,shpFun, rom, fem] = SetModel(FEM_water, FEM_air, ...
    ROM_water, ROM_air, c, n)


    %% Set general options
    
    % Global struct with common parameters for beams (immersed and in air)
    global beamData
    
    % Object with global options (solution and environment data)
    gOpt = GeneralOptions(FEM_water,FEM_air,ROM_water,ROM_air);
    
    %% Create objects
%     % Output options
%     outOpt = {false, false, true, true};
%     modalOutOpt = {1, 1, 0, 0, 0, 0, 1};

    % Structural damping coefficient
    %c = 0.09;
    
    % ROM
    rom = cell(1,2);
    if gOpt.include_ROM_water == true
        rom{2} = ROM(c,true);
        rom{2}.SetOutputOptions(false, false, true, true);
        rom{2}.genCoord.SetOutputOptions(1, 1, 0, 0, 0, 0, 1);
    end
    if gOpt.include_ROM_air == true
        rom{1} = ROM(c,false);
        rom{1}.SetOutputOptions(false, false, true, true);
        rom{1}.genCoord.SetOutputOptions(1, 1, 0, 0, 0, 0, 1);
    end
    % FEM
    fem = cell(1,2);
    fem_excitationFrequency = 0.86; % TODO - verificar frequência
    FEM_dir = strcat(FEM.data_dir,'n=',num2str(n),'\');
    if gOpt.include_FEM_water == true
        fem{2} = FEM(true,FEM_dir, fem_excitationFrequency);
        fem{2}.SetOutputOptions(false, true);
    end
    if gOpt.include_FEM_air == true
        fem{1} = FEM(false,FEM_dir, fem_excitationFrequency);
        fem{1}.SetOutputOptions(false, true);
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
    end
end

