function [] = Plot_interp(z, psi, tipos_linhas, FontSize, FontSizeLegend, ...
    FontName, pos, loc, save, nomeFig, figFormat,tg)
%% Cabe�alho


%% Corpo
figure('Name',nomeFig,'units', 'normalized', 'position', pos, 'color', 'w');
hold on; box on;
% thistab = uitab('Title',nomeFig); % build iith tab
% axes('Parent',thistab); % somewhere to plot

% Plota os gr�ficos na mesma figura
for k=1:3
    plot(psi(k,:), z, tipos_linhas(k));
end

xlabel('\psi_k(z) ', 'FontName', FontName, 'fontsize', FontSize);
ylabel('z/L', 'FontName', FontName, 'fontsize', FontSize);
set(gca, 'FontName', FontName, 'fontsize', FontSize);
legend('k = 1','k = 2','k = 3', 'FontName', FontName, 'FontSize', FontSizeLegend, 'Location', loc);

fig_dir = '.\figs\test';
% Salva figura se o booleano save_figAks for verdadeiro
if save == true
    set(gcf,'PaperSize',[3.5 6]);
    print(fullfile(fig_dir, nomeFig), figFormat, '-r1000')
end

hold off
end