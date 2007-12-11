% Test tearing on Mac Pros
% AE 2007-12-09

% settings
nSecs = 5;
refresh = 100;
nFrames = nSecs * refresh;
bgColor = 0;
color = 255;
speed = 1;
size = 1000;
radius = 100;
offset = 300;

% open PTB window
win = Screen('OpenWindow',0,bgColor);

x = repmat([0 0 0 255 255 255],1200,400);
tex = Screen('MakeTexture',win,x);

n = refresh*nSecs;
t = zeros(2,n);
for i = 1:n
    x = mod(i,2);
    Screen('DrawTexture',win,tex,[],[-400-x 0 2000-x 1200]);
    Screen('DrawingFinished',win);
    t(1,i) = GetSecs;
    t(2,i) = Screen('Flip',win);
    WaitSecs(rand(1)*0.01);
end

sca
