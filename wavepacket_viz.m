% wavepacket_viz.m
% Gaussian wavepacket animation — updated for better visualization

clear; clc;

% Spatial and time grids
x = linspace(-50, 50, 1000);    % x-axis
t = linspace(0, 2, 100);        % time steps

% Parameters of the wavepacket
x0 = -20;        % initial center position
sigma = 2;       % initial spread
k0 = 5;          % wave number (controls frequency / movement speed)
hbar = 1;        % Planck's constant
m = 1;           % particle mass

[X, T] = meshgrid(x, t);
Psi = zeros(length(t), length(x));

% Precompute wavepacket over time
for i = 1:length(t)
    ti = t(i);
    spreading = sigma^2 + 1i * hbar * ti / m;
    normalization = 1 / sqrt(sqrt(pi) * sqrt(spreading));
    Psi_t = normalization * exp( -((x - x0 - (hbar * k0 / m) * ti).^2) ./ (2 * spreading) ) ...
            .* exp(1i * (k0 * (x - x0 - (hbar * k0 / m) * ti)) );
    Psi(i, :) = Psi_t;
end

% Animation
figure;
for i = 1:length(t)
    y = abs(Psi(i, :)).^2;  % Probability density
    plot(x, y, 'b', 'LineWidth', 2);
    title(sprintf('Gaussian Wavepacket at t = %.2f', t(i)));
    xlabel('Position');
    ylabel('Probability Density');
    ylim([0, 0.5]);
    grid on;
    pause(0.05);
end

