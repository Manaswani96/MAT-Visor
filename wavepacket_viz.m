% wavepacket_viz.m
% Simulates a moving Gaussian quantum wavepacket and saves animation as GIF

clear; clc; close all;

% Parameters
x = linspace(-50, 50, 1000);     % Position space
t = linspace(0, 2, 100);         % Time steps

x0 = -20;        % Initial position
sigma = 2;       % Width
k0 = 5;          % Wave number
hbar = 1;        % Planck constant
m = 1;           % Mass

% Create output folder if needed
if ~exist('outputs', 'dir')
    mkdir('outputs');
end
gif_filename = 'outputs/wavepacket_evolution.gif';

figure('Color', 'w');

for i = 1:length(t)
    ti = t(i);
    
    spreading = sigma^2 + 1i * hbar * ti / m;
    norm = 1 / sqrt(sqrt(pi) * sqrt(spreading));
    Psi_t = norm * exp(-((x - x0 - (hbar * k0 / m) * ti).^2) ./ (2 * spreading)) ...
                .* exp(1i * (k0 * x - (hbar * k0^2 / (2 * m)) * ti));
    
    y = abs(Psi_t).^2;
    
    plot(x, y, 'b', 'LineWidth', 2);
    title(sprintf('Gaussian Wavepacket at t = %.2f', ti), 'FontSize', 14);
    xlabel('Position');
    ylabel('Probability Density');
    ylim([0, 0.5]);
    grid on;
    drawnow;

    % Save as GIF
    frame = getframe(gcf);
    img = frame2im(frame);
    [imind, cm] = rgb2ind(img, 256);

    if i == 1
        imwrite(imind, cm, gif_filename, 'gif', 'Loopcount', inf, 'DelayTime', 0.05);
    else
        imwrite(imind, cm, gif_filename, 'gif', 'WriteMode', 'append', 'DelayTime', 0.05);
    end
end

disp("✅ Wavepacket animation complete! GIF saved to: outputs/wavepacket_evolution.gif");

