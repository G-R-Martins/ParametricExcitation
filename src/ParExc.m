%% Main file
clc; close all;


%% Set general options
[gOpt, shpFun, rom, fem] = SetModel();


%% Solve EDOs, evaluate displacements and modal response, and plot results
%%% TODO - desmembrar cálculos e plots -> vide 'PlotResults.m'
[rom, fem] = AnalyzeROMs(rom, fem, shpFun);


%% Manage Finite Element Model (Giraffe) data


%% Show results
PlotResults(rom, shpFun);
