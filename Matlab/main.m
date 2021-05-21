%% Main file
% clc; close all;

%% Set general options
% Parameters = booleans to indicate which models to analyze 
% (FEM_water, FEM_air, ROM_water, ROM_air) and structural damping coefficient (c)
n=2;
[gOpt, shpFun, rom, fem] = SetModel(true,true,true,true,0.09, n); 

%% Solve EDOs, evaluate displacements and modal response, and plot results
if ~isempty(rom)
    rom = Analysis.ROMs(rom, shpFun, n);
end


%% Manage Finite Element Model (Giraffe) data
if ~isempty(fem)
    fem = Analysis.FEMs(fem);
end


%% Show results
PlotResults(rom, fem, shpFun, n);

