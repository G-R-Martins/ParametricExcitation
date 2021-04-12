%% Main file
clear; clc; close all;


%% Set general options
gOpt = GeneralOptions(0,0,1,1);


%% Set lot options
%%% such as which data to plot and save



%% Manage Finite Element Model (Giraffe) data





%% Manage Reduced Order Model (ROM) data











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
