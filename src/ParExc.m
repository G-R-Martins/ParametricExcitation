%% Main file
clear; clc; close all;


%% Set general options
gOpt = GeneralOptions(0,0,1,1);
beamData = SetBeamData();


%% Shape functions
shpFun = ShapeFunctions(beamData.L,3);


%% Set plot options
%%% such as which data to plot and save




%% Manage Reduced Order Model (ROM) data
rom_imm = ROM(0.09,true,beamData);
rom_imm_c0 = ROM(0.0,true,beamData);
rom_air = ROM(0.09,false,beamData);
rom_air_c0 = ROM(0.0,false,beamData);


%% Manage Finite Element Model (Giraffe) data
















% fh= figure;
% utb = uitabgroup(fh);
% for ii = 1:2
% f = uitab(utb,'Title',sprintf('Tab %d',ii));
% subplot(221)
% plot(rand(1,10))
% hold on;
% plot(rand(1,10))
% hold off; % necessary 
% subplot(222)
% plot(rand(1,10))
% hold on;
% plot(rand(1,10))
% hold off;% necessary 
% subplot(223)
% plot(rand(1,10))
% subplot(224)
% plot(rand(1,10))
% copyobj(fh.Children(2:end),f) %Copy subplots from figure to tab
% end
%  delete(fh.Children(2:end)) % delete subplots from figure
