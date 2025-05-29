% group_vs_phase_animator.m
% Visualize group vs phase velocity using MATLAB

clear; clc; close all;

% Parameters
k0 = 10;            % Central wavenumber
dk = 2;             % Spread in wavenumber
v_phase = 2;        % Phase velocity
v_group = 0.5;      % Group velocity
x = linspace(-50, 50, 1000);
tMax = 30;          % Duration of animation
dt = 0.2;           % Time step
frames = [];

figure('Color','w');
filename = 'group_vs_phase.gif'; % output GIF
gifOn = true; % toggle this if you don't want GIF
outputFolder = 'output';
if gifOn && ~exist(outputFolder, 'dir')
    mkdir(outputFolder);
end

for t = 0:dt:tMax
    envelope = exp(-((x - v_group*t).^2) / (2 * (10)^2));
    carrier  = cos(k0 * (x - v_phase*t));
    y = envelope .* carrier;

    plot(x, y, 'b', 'LineWidth', 2);
    title('Group vs Phase Velocity');
    xlabel('Position'); ylabel('Amplitude');
    axis([-50 50 -1 1]); grid on;
    drawnow;

    % Save to GIF
    if gifOn
        frame = getframe(gcf);
        img = frame2im(frame);
        [imind, cm] = rgb2ind(img, 256);
        if t == 0
            imwrite(imind, cm, fullfile(outputFolder, filename), 'gif', 'Loopcount', inf, 'DelayTime', dt);
        else
            imwrite(imind, cm, fullfile(outputFolder, filename), 'gif', 'WriteMode', 'append', 'DelayTime', dt);
        end
    end
end
