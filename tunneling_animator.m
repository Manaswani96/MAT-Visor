% tunneling_animator.m
% Simulate 1D Gaussian wavepacket hitting a barrier

clear; clc; close all;

% Parameters
x = linspace(-50, 50, 1000);
dx = x(2)-x(1);
tMax = 100; dt = 1;
k0 = 3;
sigma = 5;
x0 = -20;

% Barrier
V0 = 1;
V = zeros(size(x));
V(x > 0 & x < 10) = V0;

outputFolder = 'output';
gifName = 'tunneling.gif';
gifOn = true;
if gifOn && ~exist(outputFolder, 'dir')
    mkdir(outputFolder);
end

% Initial wavefunction
psi = exp(1i * k0 * x) .* exp(-((x - x0).^2) / (2 * sigma^2));
psi = psi / sqrt(trapz(abs(psi).^2));

% Time evolution setup
N = length(x);
T = tMax;
frames = [];

% Crank-Nicolson parameters
hbar = 1; m = 1;
alpha = 1i * hbar * dt / (2 * m * dx^2);
mainDiag = (1 + 2 * alpha) + 1i * dt * V / (2 * hbar);
offDiag = -alpha * ones(1, N-1);

A = diag(mainDiag) + diag(offDiag, 1) + diag(offDiag, -1);
B = diag(conj(mainDiag)) - diag(offDiag, 1) - diag(offDiag, -1);

[L, U] = lu(A);

figure('Color','w');
for t = 0:dt:T
    % Time evolution
    b = B * psi.';
    psi = U \ (L \ b);

    % Plot
    plot(x, abs(psi).^2, 'b', 'LineWidth', 2); hold on;
    plot(x, V / V0 * max(abs(psi).^2), 'r--'); hold off;
    axis([-50 50 0 0.5]); xlabel('x'); ylabel('|\psi|^2');
    title(sprintf('Tunneling Animation (t = %.1f)', t));
    drawnow;

    % Save to GIF
    if gifOn
        frame = getframe(gcf);
        img = frame2im(frame);
        [imind, cm] = rgb2ind(img, 256);
        if t == 0
            imwrite(imind, cm, fullfile(outputFolder, gifName), 'gif', 'Loopcount', inf, 'DelayTime', 0.05);
        else
            imwrite(imind, cm, fullfile(outputFolder, gifName), 'gif', 'WriteMode', 'append', 'DelayTime', 0.05);
        end
    end
end
