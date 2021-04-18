%% Main file
clc; close all;% clear all


%% Set general options
[gOpt, shpFun, rom, fem] = SetModel();


%% Solve EDOs, evaluate displacements and modal response, and plot results
if ~isempty(rom)
    rom = Analysis.ROMs(rom, shpFun, 2);
end


%% Manage Finite Element Model (Giraffe) data
if ~isempty(fem)
    fem = Analysis.FEMs(fem);
end


%% Show results
PlotResults(rom, fem, shpFun, 2);

