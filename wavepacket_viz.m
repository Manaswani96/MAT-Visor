% wavepacket_viz.m
% Simulate a Gaussian wavepacket in 1D free space
% and visualize its time evolution using MATLAB

clear; clc;

% Physical parameters
hbar = 1;          % Reduced Planck's constant (normalized)
m = 1;             % Particle mass

% Spatial domain
x = linspace(-10, 10, 1000);
dx = x(2) - x(1);

% Initial wavepacket parameters
x0 = -5;           % Initial position
k0 = 5;            % Initial momentum
sigma = 1;         % Width of the packet

% Initial wavefunction (Gaussian)
psi0 = (1/(pi*sigma^2))^(1/4) * exp(1i*k0*x) .* exp(-(x - x0).^2 / (2*sigma^2));

% Normalize wavefunction
psi0 = psi0 / sqrt(trapz(x, abs(psi0).^2));

% Time evolution settings
t_max = 2;
dt = 0.01;
t_steps = round(t_max/dt);

% K-space domain
k = linspace(-50, 50, 1000);
dk = k(2) - k(1);

% Precompute FFT of initial wavefunction
phi_k = fftshift(fft(psi0));
phi_k = phi_k / sqrt(trapz(k, abs(phi_k).^2));

% Time evolution in momentum space
figure('Color','w');
for t = 0:dt:t_max
    % Apply phase factor in momentum space
    phi_t = phi_k .* exp(-1i * (hbar * k.^2 / (2 * m)) * t);
    
    % Inverse FFT to get psi(x, t)
    psi_t = ifft(ifftshift(phi_t));

    % Plot probability density
    plot(x, abs(psi_t).^2, 'LineWidth', 2);
    xlim([-10, 10]);
    ylim([0, 0.5]);
    xlabel('x'); ylabel('|ψ(x, t)|²');
    title(sprintf('Gaussian Wavepacket Evolution at t = %.2f', t));
    grid on;
    drawnow;
end

% After your existing plotting loop in wavepacket_viz.m

nFrames = length(t);
create_gif('outputs/wavepacket_evolution.gif', nFrames, 0.05);

