%% Main file
clc; close all;


%% Set general options
[gOpt,shpFun] = SetModel();


%% Manage Reduced Order Model (ROM) data
rom_imm = ROM(0.09,true);
rom_imm_c0 = ROM(0.0,true);
rom_air = ROM(0.09,false);
rom_air_c0 = ROM(0.0,false); 

global coef 
coef = rom_imm.L_m * coef;

rom_imm.SetOutputOptions(false, false, true);


rom_imm.SolveSystemEqs(2,shpFun.modes);


%% Create tabular plot
rom_imm.OpenTabularPlot("Imersed beam - c != null");

%%% Displacements 
rom_imm.SetPlotLabels(["u(L/4,\tau)/D" "u(L/2,\tau)/D" "u(3L/4,\tau)/D"],...
    ["u'(L/4,\tau)/D" "u'(L/2,\tau)/D" "u'(3L/4,\tau)/D"]);
tit = ["u(L/4)" "u(L/2)" "u(3L/4)"];

for ii = 1:3
    rom_imm.CalculateResults(shpFun.modes, ii);
    rom_imm.CalculateSpectrum();
    rom_imm.MultiTabPlot(tit(ii),ii);
end

%%% Modal responses
if
    for ii = 1:3
    end
end

%% Manage Finite Element Model (Giraffe) data


