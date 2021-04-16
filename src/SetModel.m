function [gOpt,shpFun, rom, fem] = SetModel()


    %% Set general options
    
    % Global struct with common parameters for beams (immersed and in air)
    global beamData
    
    % Object with global options (solution and environment data)
    gOpt = GeneralOptions(0,0,1,1);
    
    %% Create objects
%     % Output options
%     outOpt = {false, false, true, true};
%     modalOutOpt = {1, 1, 0, 0, 0, 0, 1};

    % ROM
    rom = {};
    if gOpt.include_ROM_water == true
        rom{2} = ROM(0.09,true);
        rom{2}.SetOutputOptions(false, false, true, true);
        rom{2}.mAmp.SetOutputOptions(1, 1, 0, 0, 0, 0, 1);
    end
    if gOpt.include_ROM_air == true
        rom{1} = ROM(0.09,false);
        rom{1}.SetOutputOptions(false, false, true, true);
        rom{1}.mAmp.SetOutputOptions(1, 1, 0, 0, 0, 0, 1);
    end
    % FEM
    fem = {};
    if gOpt.include_FEM_water == true
        fem{2} = FEM(0.09,true);
    end
    if gOpt.include_FEM_air == true
        fem{1} = FEM(0.09,false);
    end
    
    %% Shape functions
    shpFun = ShapeFunctions(beamData.L,3,true);
    
    %%% TODO - Retirar dessa função
    if shpFun.print_modes == true
        shpFun.SinglePlot([],"Shape Functions");
    end
        
    
    %% Set 'coef'
    for cont = 1:size(rom,2)
        if rom{cont}.isImmersed == true
            rom{cont}.mor_coef = rom{2}.L_m * (shpFun.z(2)-shpFun.z(1));
        else
            rom{cont}.mor_coef = 0;
        end
    end
end

