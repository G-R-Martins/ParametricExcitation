function [] = Plot_Amp(n, A, tipos_linhas, titulos_eixos, FontSize, ...
    FontSizeLegend, FontName, pos, loc, save, nomeFig, figFormat)
%% Cabeçalho


%% Corpo
figure('name', nomeFig,'units', 'normalized', 'position', pos, 'color', 'w');
hold on; box on;

% Plota os gráficos na mesma figura
if size(A,1) > 1
    for cont=1:size(A,2)
        plot(n, A(:,cont), tipos_linhas(cont),'LineWidth',1.2+(0.5*cont-1));
    end
else
    plot(n, A, tipos_linhas(1));
end

xlabel(titulos_eixos(1), 'FontName', FontName, 'fontsize', FontSize);
ylabel(titulos_eixos(2), 'FontName', FontName, 'fontsize', FontSize);
set(gca, 'FontName', FontName, 'fontsize', FontSize);

% Legenda para o caso de plotar amplitudes das respostas modais (A_k)
if size(A,1) > 1
    legend('k = 1','k = 2','k = 3', 'FontName', FontName, 'FontSize', FontSizeLegend, 'Location', loc);
end

% Salva figura se o booleano save_figAks for verdadeiro
if save == true
    set(gcf,'PaperSize',[3.5 6]);
    print(nomeFig, figFormat, '-r1000')
end

hold off
end