% wavepacket_viz.m
% Gaussian wavepacket simulation with automatic GIF export

clear; clc;

% Create outputs folder if it doesn't exist
if ~exist('outputs', 'dir')
    mkdir('outputs');
end

% Spatial and time grids
x = linspace(-50, 50, 1000);    % x-axis positions
t = linspace(0, 2, 100);        % time steps

% Parameters of the wavepacket
x0 = -20;        % initial center position
sigma = 2;       % initial spread
k0 = 5;          % wave number (momentum-ish)
hbar = 1;        % Planck constant
m = 1;           % mass

% Allocate wavefunction data
[X, T] = meshgrid(x, t);
Psi = zeros(length(t), length(x));

% Calculate wavefunction at each time step
for i = 1:length(t)
    ti = t(i);
    spreading = sigma^2 + 1i * hbar * ti / m;
    normalization = 1 / sqrt(sqrt(pi) * sqrt(spreading));
    Psi_t = normalization * exp( -((x - x0 - (hbar * k0 / m) * ti).^2) ./ (2 * spreading) ) ...
            .* exp(1i * (k0 * (x - x0 - (hbar * k0 / m) * ti)) );
    Psi(i, :) = Psi_t;
end

% Prepare figure and GIF output
filename = 'outputs/wavepacket_evolution.gif';
figure;

for i = 1:length(t)
    y = abs(Psi(i, :)).^2;  % Probability density

    plot(x, y, 'b', 'LineWidth', 2);
    title(sprintf('Gaussian Wavepacket at t = %.2f', t(i)), 'FontSize', 14);
    xlabel('Position', 'FontSize', 12);
    ylabel('Probability Density', 'FontSize', 12);
    ylim([0, 0.5]);
    grid on;
    drawnow;

    % Capture frame and write to GIF
    frame = getframe(gcf);
    img = frame2im(frame);
    [imind, cm] = rgb2ind(img, 256);

    if i == 1
        imwrite(imind, cm, filename, 'gif', 'Loopcount', inf, 'DelayTime', 0.05);
    else
        imwrite(imind, cm, filename, 'gif', 'WriteMode', 'append', 'DelayTime', 0.05);
    end
end

disp('✨ Simulation complete! GIF saved in outputs/wavepacket_evolution.gif ✨');

