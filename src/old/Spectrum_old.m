function [freq,Amp,fd,Ad] = Spectrum_old(t, sinal)
%% Cabeçalho
%[freq,Amp,fd,Ad]=EspectroAmplitude(t,sinal)
% Entradas - t -> vetor de tempo
%            sinal -> vetor com os dados do sinal
% Saídas   - freq -> vetor de frequencias
%          - Amp  -> vetor de amplitudes
%          - fd   -> frequencia dominante
%          - Ad   -> amplitude na frequencia dominante

%% Corpo
% Calcula o espectro de amplitude do sinal
N = length(t);
deltat = t(2)-t(1);
fs = 1/deltat;
freq = [0:N-1]*fs/N;
Xs = fft(sinal);
Amp = abs(Xs)/N;
Amp = 2*Amp(1:fix(N/2));
[Ad,indice] = max(Amp);

% Normaliza pela frequência do primeiro modo
freq = freq(1:fix(N/2))*2*pi;

fd = freq(indice);
end

