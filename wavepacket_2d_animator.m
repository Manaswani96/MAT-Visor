% wavepacket_2d_animator.m
% 2D Gaussian wavepacket animation

clear; clc; close all;

% Parameters
x = linspace(-10, 10, 200);
y = linspace(-10, 10, 200);
[X, Y] = meshgrid(x, y);

kx = 5; ky = 3;    % Initial momenta
sigma = 1;        % Width
tMax = 20; dt = 0.2;
frames = [];

outputFolder = 'output';
gifName = 'wavepacket_2d.gif';
gifOn = true;
if gifOn && ~exist(outputFolder, 'dir')
    mkdir(outputFolder);
end

figure('Color','w');
for t = 0:dt:tMax
    X0 = kx * t / 2;
    Y0 = ky * t / 2;

    envelope = exp(-((X - X0).^2 + (Y - Y0).^2) / (2 * sigma^2));
    phase = cos(kx * X - ky * Y - (kx^2 + ky^2) * t / 2);
    psi = envelope .* phase;

    surf(X, Y, psi, 'EdgeColor', 'none');
    axis([-10 10 -10 10 -1 1]);
    xlabel('x'); ylabel('y'); zlabel('\psi');
    title(sprintf('2D Gaussian Wavepacket at t = %.1f', t));
    view(3); drawnow;

    if gifOn
        frame = getframe(gcf);
        img = frame2im(frame);
        [imind, cm] = rgb2ind(img, 256);
        if t == 0
            imwrite(imind, cm, fullfile(outputFolder, gifName), 'gif', 'Loopcount', inf, 'DelayTime', dt);
        else
            imwrite(imind, cm, fullfile(outputFolder, gifName), 'gif', 'WriteMode', 'append', 'DelayTime', dt);
        end
    end
end
