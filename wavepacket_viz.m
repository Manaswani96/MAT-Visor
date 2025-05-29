% wavepacket_viz.m
% Simulates a Gaussian quantum wavepacket and saves animation as GIF

clear; clc; close all;

% Create output folder if it doesn't exist
if ~exist('outputs', 'dir')
    mkdir('outputs');
end

% Parameters
x = linspace(-50, 50, 1000);     % Position space
t = linspace(0, 2, 100);         % Time steps

x0 = -20;        % Initial position
sigma = 2;       % Width
k0 = 5;          % Wave number
hbar = 1;        % Planck constant
m = 1;           % Mass

% Allocate wavefunction array
Psi = zeros(length(t), length(x));

% Calculate wavefunction over time
for i = 1:length(t)
    ti = t(i);
    spreading = sigma^2 + 1i * hbar * ti / m;
    norm = 1 / sqrt(sqrt(pi) * sqrt(spreading));
    Psi_t = norm * exp(-((x - x0 - (hbar * k0 / m) * ti).^2) ./ (2 * spreading)) ...
                .* exp(1i * (k0 * (x - x0 - (hbar * k0 / m) * ti)));
    Psi(i, :) = Psi_t;
end

% Setup GIF file
gif_filename = 'outputs/wavepacket_evolution.gif';

figure('Color', 'w');
for i = 1:length(t)
    y = abs(Psi(i, :)).^2;

    plot(x, y, 'b', 'LineWidth', 2);
    title(sprintf('Gaussian Wavepacket at t = %.2f', t(i)), 'FontSize', 14);
    xlabel('Position');
    ylabel('Probability Density');
    ylim([0, 0.5]);
    grid on;
    drawnow;

    % Capture frame for GIF
    frame = getframe(gcf);
    img = frame2im(frame);
    [imind, cm] = rgb2ind(img, 256);

    if i == 1
        imwrite(imind, cm, gif_filename, 'gif', 'Loopcount', inf, 'DelayTime', 0.05);
    else
        imwrite(imind, cm, gif_filename, 'gif', 'WriteMode', 'append', 'DelayTime', 0.05);
    end
end

disp("✅ Animation complete! GIF saved to: outputs/wavepacket_evolution.gif");
