function [] = Plot_disp(t, x, z, permaTime, modo1, modo2, modo3, FontSize, ...
    FontSizeLegend, FontName, pos, loc, save, nomeFig, figFormat)
%% Cabeçalho

%% Corpo

% "Extrai" o tempo desejado (em regime permanente)
[lin,~] = find(t(:,1)>=permaTime(1) & t(:,1)<=permaTime(2));
inicio = lin(1);
fim = lin(size(lin,1));
t_plot=t(inicio:fim); % Novo vetor tempo

% Matriz com as coordenadas ao longo do tempo
mat = (x(inicio:fim,1)*modo1+x(inicio:fim,2)*modo2+x(inicio:fim,3)*modo3)';

% Abre uma figura
% figure('name', nomeFig,'units', 'normalized', 'position', pos, 'color', 'w');
% box on;
thistab = uitab('Title',nomeFig); % build iith tab
axes('Parent',thistab); % somewhere to plot

% Plota dados e reformata cores
pcolor(t_plot, z, mat)
shading 'Interp'

% Barra de cores
c = colorbar;
c.Label.String = 'u(z,\tau)/D';
c.Label.FontSize = FontSize;
c.Label.FontName = FontName;

% Legendas
xlabel('\tau = t\omega_1', 'FontName', FontName, 'fontsize', FontSize)
ylabel('z/L', 'FontName', FontName, 'fontsize', FontSize)
set(gca, 'FontName', FontName, 'fontsize', FontSize)

% Salva figura
if save == true
    set(gcf,'PaperSize',[3.5 6]);
    print(nomeFig, figFormat, '-r1000')
end

end