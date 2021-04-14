function [gOpt,shpFun] = SetModel()


    %% Set general options

    % Global struct with common parameters for beams (immersed and in air)
    global beamData

    % Object with global options (solution and environment data)
    gOpt = GeneralOptions(0,0,1,1);


    %% Shape functions
    shpFun = ShapeFunctions(beamData.L,3,true);
    
    %%% TODO - Retirar dessa função
    if shpFun.print_modes == true
        shpFun.SinglePlot([],"Shape Functions");
    end
    
    
    %% ROM and FEM options
    
    
    
end

