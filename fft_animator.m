% fft_animator.m
% Animated FFT visualization of a time-varying signal

clear; close all; clc;

% --- Settings ---
fs = 1000;              % Sampling frequency (Hz)
t = 0:1/fs:2;           % Time vector (2 seconds)
signal = sin(2*pi*10*t) + 0.5*sin(2*pi*25*t);  % Example: Sum of 10Hz and 25Hz

% Create figure
figure('Color', 'w');
title('Live FFT Spectrum'); xlabel('Frequency (Hz)'); ylabel('Magnitude');
grid on;
xlim([0 100]); ylim([0 1]);
hold on;

frameRate = 30;
frameStep = round(length(t)/frameRate);

% Animate FFT
for i = 1:frameStep:length(t)
    segment = signal(1:i);
    L = length(segment);
    f = fs*(0:(L/2))/L;
    
    Y = fft(segment);
    P2 = abs(Y/L);
    P1 = P2(1:L/2+1);
    P1(2:end-1) = 2*P1(2:end-1);
    
    cla;
    plot(f, P1, 'LineWidth', 1.5);
    title(['FFT Spectrum @ t = ', num2str(t(i), '%.2f'), ' s']);
    xlabel('Frequency (Hz)'); ylabel('Magnitude');
    xlim([0 100]); ylim([0 1]);
    grid on;
    
    drawnow;
end
