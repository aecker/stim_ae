% Test PhotodiodeTimer
% AE 2007-10-26

% settings
nSecs = 100;
refresh = 100;
nFrames = nSecs * refresh;
bgColor = 255;

% open PTB window
win = Screen('OpenWindow',0);
% win = Screen('OpenWindow',0,0,[1000 0 3200 1200]);
% rect = Screen('Rect',win);
Screen('FillRect',win,bgColor);

timer = PhotoDiodeTimer(nFrames);
for i = 1:nFrames
    timer = swap(timer,win);
    % have it miss frame flips randomly
    t = GetSecs + randn(1) * 4 / 1000;
    while GetSecs < t, end
end
sca

