% wavepacket_animator.m
% Simulates a moving Gaussian wave packet and saves animation as a GIF

clear; close all; clc;

% Parameters
x = linspace(-50, 50, 1000);
x0 = -20;       % Initial center
sigma = 2;      % Width
k0 = 5;         % Initial momentum
hbar = 1;       % Reduced Planck's constant
m = 1;          % Mass
t_total = 1;    
nFrames = 40;
t = linspace(0, t_total, nFrames);
frames(nFrames) = struct('cdata', [], 'colormap', []);

% Create figure
fig = figure('Color','w');
filename = 'wavepacket.gif';

for i = 1:nFrames
    ti = t(i);
    normalization = (1/(pi * sigma^2))^0.25;
    envelope = exp(-(x - (x0 + (hbar * k0 / m) * ti)).^2 / (2 * sigma^2));
    phase = exp(1i * (k0 * x - (hbar * k0^2 / (2 * m)) * ti));
    psi = normalization * envelope .* phase;
    y = abs(psi).^2;

    plot(x, y, 'b', 'LineWidth', 2);
    xlim([-50, 50]); ylim([0, 0.3]);
    xlabel('x'); ylabel('|ψ(x,t)|²');
    title(sprintf('Wave Packet at t = %.2f', ti), 'FontSize', 14);
    grid on; drawnow;

    % Save frame for GIF
    frame = getframe(fig);
    img = frame2im(frame);
    [imind, cm] = rgb2ind(img, 256);

    if i == 1
        imwrite(imind, cm, filename, 'gif', 'Loopcount', inf, 'DelayTime', 0.1);
    else
        imwrite(imind, cm, filename, 'gif', 'WriteMode', 'append', 'DelayTime', 0.1);
    end
end

disp(['GIF saved as ', filename]);
