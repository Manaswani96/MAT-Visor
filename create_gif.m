% Capture current MATLAB figure as animated GIF

function create_gif(filename, nFrames, delay)
% filename - output GIF file name (string)
% nFrames - number of frames in the GIF
% delay - delay time between frames (seconds)

if nargin < 3
    delay = 0.1; % default delay
end

for k = 1:nFrames
    frame = getframe(gcf);
    img = frame2im(frame);
    [imind, cm] = rgb2ind(img, 256);

    if k == 1
        imwrite(imind, cm, filename, 'gif', 'Loopcount', inf, 'DelayTime', delay);
    else
        imwrite(imind, cm, filename, 'gif', 'WriteMode', 'append', 'DelayTime', delay);
    end
end
end
