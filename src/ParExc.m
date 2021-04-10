clc; close all;

%% Parâmetros da solução

% Em água (true) ou ar (false)
imerso = true;

% Condições iniciais
x0 = 0.1*[1;1;1;0;0;0];

% Tempo
ti = 0; dt = 0.05; tf = 10000; % inicio ; passo ; tempo total
permaTime = [8000 8050]; % Para plotar série "inteira"

% Variação do parâmetro 'n'
n0 = 1; dn = 0.05; nf = 7; % dn não pode ser zero

n_plot = [2.0 2.15 4.0 6.0 8.0]; % Valores de interesse

%% Formatação e booleanos para plotar/salvar figuras

% Intervalo de para plotagem das séries temporais
lim = permaTime; % deslocamento normalizado

% Booleanos
% Salvar ou não salvar figuras
save_figU = false;      % Resultados série temporal e espectro de amplitude
save_figA = false;      % Espaços de fase e séries temporais das funções Aks
save_figInterp = false;  % Funções de interpolação dos modos de vibrar
save_matDesloc = false; % Série temporal na forma de um único gráfico de cores
save_respAmpli = false;  % Resposta total
save_respAmpli_Ak = false; % Respostas modais

% Define se serão plotados os espectros de amplitude
espectroU = true; % para série temporal (u)
espFaseU = false;  % plota espaço de fase de u x u' (junto com espectro)

espectroA = false; % false -> só os espaços de fase para os Aks 
espFaseA = false;  % plota espaço de fase de A x A' (junto com espectro)

figInterp = true;  % Plota modos
matDesloc = true;  % plotar série temporal na forma de matriz
respAmpli = true;  % plotar resposta da amplitude
respAk = true;      % plotar resposta modais (A_k)

% Formatação
FontSize = 18;
FontSizeLegend = 16;
FontName = "Cambria Math"; % Igual para eixos, valores e legendas
MarkerSize = 15;
pos = [.1 0.1 .8 .8]; % figura
loc = ["northeast" "southwest" "eastoutside"]; % legenda
tipos_graficos = ["-k";"-r";"-g";"-b";".r"; "-r"];
eixos_graficos = ["u(L/4,\tau)/D" "u(L/2,\tau)/D" "u(3L/4,\tau)/D"; ...
    "u'(L/4,\tau)/D" "u'(L/2,\tau)/D" "u'(3L/4,\tau)/D";...
    "A_1(\tau)/D" "A_2(\tau)/D" "A_3(\tau)/D"; ...
    "A_1'(\tau) / D" "A_2'(\tau) / D" "A_3'(\tau) / D"];

% Nomes das figuras a serem salvas
nomes_figuras = ["u25L" "u50L" "u75L"; "A1" "A2" "A3"; "p25" "p50" "p75"];
% Formato a ser salvo
figFormat = '-dpng';

%% Dados do problema
diam = 22.2/1000;
L = 2.552;
At = L*0.01;
c = 0.09;
rho = 1025;
EI = 0.056;
EA = 1200;
grav = 9.81;
Tt = 38.36;
f1 = 0.83;
w1 = 2*pi*f1;
W1 = 2*w1;
mu = 1.19;
mu_d = rho*pi*diam^2/4;
if imerso == true
    mu_a = mu_d; % Para ter Ca=1
    Cd = 1.2;
    gamma = mu*grav - rho*grav*pi*diam^2/4;
else
    mu_a = 0; % Para ter Ca=0
    Cd = 0;
    gamma = mu*grav;
end

%% Adimensionais
m = mu/mu_d;
Ca = mu_a/mu_d;

% Lambda_M (Morison)
L_m = diam^2/(L*mu_d*(m+Ca))*rho*Cd;

% Alphas
a = [c/(mu_d*(m+Ca)*w1) ...
    -40*gamma/(9*mu_d*(m+Ca)*w1^2*L) ...
    diam^2*EA/(4*mu_d*(m+Ca)*w1^2)*(pi/L)^4 ...
    diam^2*EA/(mu_d*(m+Ca)*w1^2)*(pi/L)^4 ...
    9*diam^2*EA/(4*mu_d*(m+Ca)*w1^2)*(pi/L)^4];

% Betas
b = [a(1) ...
    -312*gamma/(25*mu_d*(m+Ca)*w1^2*L) ...
    a(2) ...
    a(4) ...
    diam^2*EA/(4*mu_d*(m+Ca)*w1^2)*(2*pi/L)^4 ...
    9*diam^2*EA/(mu_d*(m+Ca)*w1^2)*(pi/L)^4];

% Gammas
g = [a(1) b(2) b(6) a(5) diam^2*EA/(4*mu_d*(m+Ca)*w1^2)*(3*pi/L)^4];

% Epsilons
ep = [(EA/L)*(pi/L)^2*(At/(mu_d*(m+Ca)*w1^2)) ...
    (EA/L)*((2*pi)/L)^2*(At/(mu_d*(m+Ca)*w1^2)) ...
    (EA/L)*((3*pi)/L)^2*(At/(mu_d*(m+Ca)*w1^2))];

% Deltas
d = [(EI/(mu_d*(m+Ca)*w1^2))*(pi/L)^4-(1/2)*((gamma*L)/(mu_d*(m+Ca)*w1^2))*(pi/L)^2+(pi/L)^2*(Tt/(mu_d*(m+Ca)*w1^2)) ...
    (EI/(mu_d*(m+Ca)*w1^2))*(2*pi/L)^4-(1/2)*((gamma*L)/(mu_d*(m+Ca)*w1^2))*(2*pi/L)^2+(2*pi/L)^2*(Tt/(mu_d*(m+Ca)*w1^2)) ...
    (EI/(mu_d*(m+Ca)*w1^2))*(3*pi/L)^4-(1/2)*((gamma*L)/(mu_d*(m+Ca)*w1^2))*(3*pi/L)^2+(3*pi/L)^2*(Tt/(mu_d*(m+Ca)*w1^2))];

%% Funções de interpolação

% Argumentos dos senos das funções de interpolação
arg = [pi/L*L/4 pi/L*L/2 pi/L*3*L/4];

% Discretização vertical (adimensionalizada)
z = linspace(0,L,1000);

% Adimensional incluindo já o passo de tempo (regra dos retângulos)
mor = L_m*(z(2)-z(1));

% Modos de vibrar
modo1 = sin(pi/L*z);
modo2 = sin(2*pi/L*z);
modo3 = sin(3*pi/L*z);

if figInterp == true
    Plot_interp(z/L, [modo1' modo2' modo3'], ["-k" "--r" "-.b"], FontSize, FontSizeLegend, ...
        FontName, [.1 .1 .5 .8], loc(2), save_figInterp, "funcoes de interpolacao", figFormat)
end

%%  Resolução do modelo para o(s) valor(es) de 'n'

% Dados para plotar amplitude da resposta e da resp modal
ampli_n = zeros(1,nf/dn) ; vet_n = zeros(1,nf/dn); 
ampli_Ak_n = zeros(nf/dn,size(arg,2)); % [A_1 A_2 A_3]
cont = 1; % para iterar nos elementos dos vetores definidos acima

for n=n0:dn:nf
    % Mostra o valor atual de 'n' na janela de comando
    fprintf("n = %f\n", n);
    
    %%% Solução do sistema de EDOs
    
    % Vetor tempo
    t = ti:dt:tf;
    % Resolve sistema de equações
    f = @(t,x) Integrator(t,x,a,b,g,d,ep,n,mor,modo1,modo2,modo3);
    [t_sol,x_sol] = ode45(f,t,x0);
    
    %%% Gráficos
    
    % Para instabilidades de Mathieu
    if ismember(n,n_plot)
        disp("ploting. . .")
        % Deslocamentos
        for k=1:size(arg,2)
            %%% Deslocamentos e velocidades
            if imerso == true
                U_k = x_sol(:,1)*modo1(size(modo1,2)*k/4) + x_sol(:,2)*modo2(size(modo2,2)*k/4) + x_sol(:,3)*modo3(size(modo3,2)*k/4);
                dU_k = x_sol(:,1+3)*modo1(size(modo1,2)*k/4) + x_sol(:,2+3)*modo2(size(modo2,2)*k/4) + x_sol(:,3+3)*modo3(size(modo3,2)*k/4);
            else
                U_k = x_sol(:,1)*sin(arg(k)) + x_sol(:,2)*sin(2*arg(k)) + x_sol(:,3)* sin(3*arg(k));
                dU_k = x_sol(:,1+3)*sin(arg(k)) + x_sol(:,2+3)*sin(2*arg(k)) + x_sol(:,3+3)* sin(3*arg(k));
            end
            
            % Espectros de amplitude do sinal de deslocamentos
            if espectroU == true
                [vetor_freq,vetor_amp,fd,Ad] = Spectrum(t_sol,U_k);
            else
                vetor_freq = []; vetor_amp=[];
            end
            
            % Plotagem dos deslocamentos e espaços de fase
            if espectroU == true || espFaseU == true
                Plot_general(t_sol, U_k, dU_k, eixos_graficos(1,k), eixos_graficos(2,k),...
                    "Amplitude", save_figU, vetor_freq, vetor_amp, tipos_graficos, ...
                    FontSize, FontSizeLegend, FontName, pos, loc, lim, [0 6], ...
                    strcat(nomes_figuras(1,k)," - n=",string(n)), espectroU, espFaseU, figFormat)
            end
            %%% Funções modais
            
            % Espectros de amplitude do sinal de deslocamentos
            if espectroA == true
                [vetor_freq,vetor_amp,fd,Ad] = Spectrum(t_sol,x_sol(:,k));
            else
                vetor_freq = []; vetor_amp=[];
            end
            
            % Plotagem das respostas modais e espaços de fase
            if espectroA == true || espFaseA == true
                Plot_general(t_sol, x_sol(:,k), x_sol(:,k+3), eixos_graficos(3,k), eixos_graficos(4,k),...
                    "Amplitude", save_figA, vetor_freq, vetor_amp, tipos_graficos, ...
                    FontSize, FontSizeLegend, FontName, pos, loc, lim, [0 6], ...
                    strcat(nomes_figuras(2,k)," - n=",string(n)), espectroA, espFaseA, figFormat)
            end
        end
    end
    
    % Matrizes com séries temporais de deslocamentos
    if matDesloc == true && ismember(n,n_plot)
        Plot_disp(t_sol, x_sol, z/L, permaTime, modo1, modo2, modo3, ...
            FontSize, FontSizeLegend, FontName, pos, loc, ...
            save_matDesloc,  strcat("Deformadas - n=",string(n)), figFormat)
    end
    
    % Amplitude da resposta
    if respAmpli == true || respAk == true
        % Identifica o intervalo de tempo desejado (em regime permanente)
        [lin,~] = find(t_sol(:,1)>=permaTime(1) & t_sol(:,1)<=permaTime(2));
        inicio = lin(1); fim = lin(size(lin,1));
        
        % Resposta total
        if respAmpli == true
            ampli_n(1,cont) = max(x_sol(inicio:fim,1)*modo1+x_sol(inicio:fim,2)*modo2+x_sol(inicio:fim,3)*modo3,[],'all');
            vet_n(1,cont) =  n;
        end
        
        % Resposta modal
        if respAk == true
            ampli_Ak_n(cont,:) = [max(x_sol(inicio:fim,1)) max(x_sol(inicio:fim,2)) max(x_sol(inicio:fim,3))];
        end
    end
    
    % Atualiza n e contador da coluna dos vetores da amplitude da resposta
    cont = cont + 1;
end

% Plota respostas máximas
if respAmpli == true
    Plot_Amp(vet_n, ampli_n, tipos_graficos, ["n" "Amplitude of response"], ...
        FontSize, FontSizeLegend, FontName, pos, loc, save_respAmpli, "Ampli_n", figFormat)
end

if respAk == true
    Plot_Amp(vet_n, ampli_Ak_n, ["-k" "--g" "-.b"], ["n" "max\{A_k\}"], ...
        FontSize, FontSizeLegend, FontName, pos, loc(1), save_respAmpli_Ak, "Ampli_Ak_n", figFormat)
end