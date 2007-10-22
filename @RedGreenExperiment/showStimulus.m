function e = showStimulus(e)
% Show a rectangle of solid color.

% some member variables..
win = get(e,'win');
con = get(e,'con');
curParams = get(e,'curParams');

% some shortcuts
rect = Screen('Rect',win);

% show rectangle
crect = CenterRect([0 0 curParams.size'],rect);
Screen('FillRect',win,curParams.color',crect);
startTime = Screen('Flip',win);

% compute timeout
endTime = Inf;

% put start time
e = addEvent(e,'showStimulus',startTime);

% control loop: we remove the stimulus after params.stimTime seconds or a
% tcp abort command, whichever comes first.
firstTrial = true;
while GetSecs < endTime
    
    % check for abort signal
    [e,abort] = checkForAbort(e);
    if abort
        
        % read out buffer swap times and reset timer
        swapTimes = getSwapTimes(e.photoDiodeTimer);
        e = setTrialData(e,'swapTimes',swapTimes);
        e.photoDiodeTimer = reset(e.photoDiodeTimer);
        
        return
    end

    % draw colored rectangle
    Screen('FillRect',win,curParams.color',crect);

    % draw photodiode spot; do buffer swap and keep timestamp
    e.photoDiodeTimer = swap(e.photoDiodeTimer,win);
    
    % compute timeout
    if firstTrial
        startTime = getSwapTimes(e.photoDiodeTimer);
        endTime = startTime + curParams.stimTime/1000;
        firstTrial = false;
    end
    
end

% send 'completed' to state system
pnet(con,'write',uint8(1));

% read out buffer swap times and reset timer
swapTimes = getSwapTimes(e.photoDiodeTimer);
e = setTrialData(e,'swapTimes',swapTimes);
e.photoDiodeTimer = reset(e.photoDiodeTimer);

% clear screen
e = clearScreen(e);

