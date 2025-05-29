% wavepacket_viz.m
% Simulates a moving Gaussian wavepacket and exports to GIF

clear; clc; close all;

% Create output directory
if ~exist('outputs', 'dir')
    mkdir('outputs');
end

% Parameters
x = linspace(-50, 50, 1000);    % Space
t = linspace(0, 1, 80);         % Time steps

x0 = -20;       % Initial position
sigma = 2;      % Width
k0 = 5;         % Wave number
hbar = 1;       % Reduced Planck constant
m = 1;          % Mass

gif_filename = 'outputs/wavepacket_evolution.gif';

figure('Color', 'w');
set(gcf, 'Position', [100, 100, 700, 400]);  % Bigger figure

for i = 1:length(t)
    ti = t(i);

    % Real Gaussian wavepacket with group velocity
    normalization = (1/(pi * sigma^2))^0.25;
    phase = exp(1i * (k0 * x - (hbar * k0^2 / (2 * m)) * ti));
    envelope = exp(-(x - (x0 + (hbar * k0 / m) * ti)).^2 / (2 * sigma^2));
    psi = normalization * envelope .* phase;
    
    % Plot probability density
    plot(x, abs(psi).^2, 'b', 'LineWidth', 2);
    ylim([0, 0.3]);
    xlim([-50, 50]);
    xlabel('x');
    ylabel('|ψ(x,t)|²');
    title(sprintf('Gaussian Wavepacket at t = %.2f', ti));
    grid on;
    drawnow;

    % GIF
    frame = getframe(gcf);
    img = frame2im(frame);
    [imind, cm] = rgb2ind(img, 256);
    if i == 1
        imwrite(imind, cm, gif_filename, 'gif', 'Loopcount', inf, 'DelayTime', 0.05);
    else
        imwrite(imind, cm, gif_filename, 'gif', 'WriteMode', 'append', 'DelayTime', 0.05);
    end
end

disp("✅ Done! GIF saved to 'outputs/wavepacket_evolution.gif'");
