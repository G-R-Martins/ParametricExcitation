function [] = Plot_interp(z, psi, tipos_linhas, FontSize, FontSizeLegend, ...
    FontName, pos, loc, save, nomeFig, figFormat)
%% Cabeçalho


%% Corpo
figure('units', 'normalized', 'position', pos, 'color', 'w');
hold on; box on;

% Plota os gráficos na mesma figura
for k=1:3
    plot(psi(:,k), z, tipos_linhas(k));
end

xlabel('\psi_k(z) ', 'FontName', FontName, 'fontsize', FontSize);
ylabel('z/L', 'FontName', FontName, 'fontsize', FontSize);
set(gca, 'FontName', FontName, 'fontsize', FontSize);
legend('k = 1','k = 2','k = 3', 'FontName', FontName, 'FontSize', FontSizeLegend, 'Location', loc);

% Salva figura se o booleano save_figAks for verdadeiro
if save == true
    set(gcf,'PaperSize',[3.5 6]);
    print(nomeFig, figFormat, '-r1000')
end

hold off
end