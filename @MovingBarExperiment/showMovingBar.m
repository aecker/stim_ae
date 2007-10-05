function e = showMovingBar(e)
% show moving bar

% some member variables..
win = get(e,'win');
con = get(e,'con');
curParams = get(e,'curParams');
curIndex = get(e,'curIndex');

% determine starting position
len = curParams.trajectoryLength;
if rand(1) > 0.9
    startPos = curParams.trajectoryStart;
    angle = curParams.trajectoryAngle / 180 * pi;
else
    startPos = curParams.trajectoryStart + len * [sin(angle); cos(angle)];
    angle = (curParams.trajectoryAngle + 180) / 180 * pi;
end

% put start time
startTime = GetSecs;
firstTrial = true;
s = 0;
while s < len

    % check for abort signal
    [e,abort] = checkForAbort(e);
    if abort
        % read out buffer swap times and reset timer
        swapTimes = getSwapTimes(e.photoDiodeTimer);
        e = putTrialData(e,'swapTimes',swapTimes);
        e.photoDiodeTimer = reset(e.photoDiodeTimer);
        return
    end

    % determine current position
    s = (GetSecs - startTime) * curParams.speed / 1000;
    pos = startPos + s * [sin(angle); cos(angle)];

    % draw colored rectangle
    rect = [pos - curParams.barSize/2; pos + curParams.barSize/2];
    Screen('FillRect',win,curParams.color',rect);

    % draw photodiode spot; do buffer swap and keep timestamp
    e.photoDiodeTimer = swap(e.photoDiodeTimer,win);
    
    % compute timeout
    if firstTrial
        startTime = getSwapTimes(e.photoDiodeTimer);
        e = addEvent(e,'showStimulus',startTime);
        firstTrial = false;
    end
    
end

% send 'completed' to state system
pnet(con,'write',uint8(1));

% read out buffer swap times and reset timer
swapTimes = getSwapTimes(e.photoDiodeTimer);
e = putTrialData(e,'swapTimes',swapTimes);
e.photoDiodeTimer = reset(e.photoDiodeTimer);

% clear screen
e = clearScreen(e);
