% Test PhotodiodeTimer
% AE 2007-10-26

% settings
nSecs = 300;
refresh = 100;
nFrames = nSecs * refresh;
bgColor = 255;

% open PTB window
win = Screen('OpenWindow',0);
rect = Screen('Rect',win);
Screen('FillRect',win,bgColor);

timer = PhotoDiodeTimer(nFrames);
for i = 1:nFrames
    timer = swap(timer,win);
    % have it miss frame flips randomly
%     t = GetSecs + randn(1) * 4 / 1000;
%     t = GetSecs+3;
%     while GetSecs < t, end
end
sca

