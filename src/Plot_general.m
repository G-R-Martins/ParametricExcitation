function []=Plot_general(x, y, dy, titulo_y, titulo_dy, titulo_Amp, save, ...
    vetor_freq, vetor_amp, tipos_graficos, ...
    FontSize, FontSizeLegend, FontName, pos, loc, ...
    lim_y, lim_freq, nomeFig, espectro, espFase, figFormat, thistab)
%% Cabeçalho

%% Corpo
% Abre uma figura com fundo branco e eixos
% figure('name',nomeFig,'units', 'normalized', 'position', pos, 'color', 'w');
% hold on; box on;

thistab0 = uitab('Title',nomeFig,'BackgroundColor', 'w'); % build iith tab
axes('Parent',thistab0); % somewhere to plot
if espectro == true && espFase == true
    % Descrição temporal do deslocamento normalizado
    subplot(2,2,2)
    hold on; box on;
    xlabel('\tau = t\omega_1','FontName',FontName,'fontsize',FontSize)
    ylabel(titulo_y,'FontName',FontName,'fontsize',FontSize)
    set(gca, 'fontsize', FontSize, 'xlim', lim_y)

    plot(x,y,'k')

    % Espectro de amplitude
    subplot(2,2,4)
    hold on; box on;
    xlabel('f/f_1', 'FontName', FontName, 'fontsize', FontSize)
    ylabel(titulo_Amp, 'FontName', FontName, 'fontsize', FontSize)
    set(gca, 'FontName', FontName, 'fontsize', FontSize, 'xlim', lim_freq)

    plot(vetor_freq, vetor_amp ,'k')
    
    % Espaço de fase
    %%% Para plotar o espaço de fase do intervalo de interesse, deve-se extrair
    %%% os valores desse intervalo antes
    [lin,~] = find(x(:,1)>=lim_y(1) & x(:,1)<=lim_y(2));
    inicio = lin(1);
    fim = lin(size(lin,1));
    
    subplot(2,2,[1 3])
    hold on; box on;
    xlabel(titulo_y, 'FontName', FontName, 'fontsize', FontSize)
    ylabel(titulo_dy, 'FontName', FontName, 'fontsize', FontSize)
    set(gca, 'FontName', FontName, 'fontsize', FontSize)
    
%     plot(y(inicio:fim,1), dy(inicio:fim,1) ,'k');
    plot(y(inicio:fim,1), dy(inicio:fim,1) ,'k');
elseif espectro == true
    % Deslocamento normalizado
    subplot(2,1,1)
    hold on; box on;
    xlabel('\tau = t\omega_1', 'FontName', FontName, 'fontsize',FontSize);
    ylabel(titulo_y,'FontName', FontName, 'fontsize', FontSize);
    set(gca, 'FontName', FontName, 'fontsize', FontSize, 'xlim', lim_y);

    % plota série temporal do deslocamento normalizado
    plot(x,y,tipos_graficos(1,1));

    % Espectro de amplitude
    subplot(2,1,2)
    hold on; box on;
    xlabel('f/f_1', 'FontName', FontName, 'fontsize', FontSize)
    ylabel(titulo_Amp, 'FontName', FontName, 'fontsize', FontSize)
    set(gca, 'FontName', FontName, 'fontsize', FontSize, 'xlim', [0 5])

    plot(vetor_freq, vetor_amp, tipos_graficos(1,1))
else
    xlabel('\tau = t\omega_1', 'FontName', FontName, 'fontsize',FontSize);
    ylabel(titulo_y,'FontName', FontName, 'fontsize', FontSize);
    set(gca, 'FontName', FontName, 'fontsize', FontSize, 'xlim', lim_y);
    
    % plota série temporal do deslocamento normalizado
    plot(x,y,tipos_graficos(1,1));
end

if save == true
     set(gcf,'PaperSize',[3.5 6]);
     print(nomeFig, figFormat, '-r1000')
end

end