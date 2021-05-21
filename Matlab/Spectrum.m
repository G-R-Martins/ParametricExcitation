function [freq, Amp, fd, Ad] = Spectrum(t, signal)
    %% Header
    % Inputs  - t -> vector with time discretization
    %           signal -> vector with data signal
    % Outputs - freq -> vector with frequency data
    %         - Amp  -> vector with amplitude data
    %         - fd   -> dominant frequency
    %         - Ad   -> amplitude of the dominant frequency

    %% Function
    N = length(t);
    deltat = t(2)-t(1);
    fs = 1/deltat;
    freq = [0:N-1]*fs/N;
    Xs = fft(signal);
    Amp = abs(Xs)/N;
    Amp = 2*Amp(1:fix(N/2));
    [Ad,index]= max(Amp);

    % Normalize with first mode frequency
    freq = freq(1:fix(N/2))*2*pi;

    fd = freq(index);
end