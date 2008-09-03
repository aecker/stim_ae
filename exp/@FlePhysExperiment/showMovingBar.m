function e = showMovingBar(e,varargin)
% Moving bar for Flash-Lag effect electrophysiology.
% AE 2008-09-02

% parameters
barSize    = getParam(e,'barSize');
dx         = getParam(e,'dx');
stimCenter = getParam(e,'stimCenter');
trajAngle  = getParam(e,'trajectoryAngle');
trajLen    = getParam(e,'trajectoryLength');
nLocs      = getParam(e,'numFlashLocs');
dir        = getParam(e,'direction');         % \in {0,1}

% determine number of frames
nFrames = ceil(trajLen / dx);
if mod(nFrames,2) ~= mod(nLocs,2)
    nFrames = nFrames - 1;
end

% determine starting position (this way we make sure it will hit the flash 
% locations)
angle = (trajAngle + 180 * dir) / 180 * pi;
startPos = -(nFrames - 1) / 2 * dx;

firstTrial = true;
abort = false;
s = zeros(1,nFrames);
rect = zeros(4,nFrames);
center = zeros(2,nFrames);
for i = 1:nFrames
    
    % check for abort signal
    [e,abort] = tcpMiniListener(e,{'netAbortTrial','netTrialOutcome'});
    if abort
        break
    end

    % draw colored rectangle
    s(i) = (-1)^dir * (startPos + (i-1) * dx);
    center(:,i) = stimCenter + s(i) * [cos(angle); -sin(angle)];
    rect(:,i) = [center(:,i) - barSize/2; center(:,i) + barSize/2];
    Screen('DrawTexture',get(e,'win'),e.tex,[],rect(:,i),-angle*180/pi); 
    
    % fixation spot
    drawFixSpot(e);

    % buffer swap
    e = swap(e);
    
    % log start time
    if firstTrial
        startTime = getLastSwap(e);
        e = addEvent(e,'showStimulus',startTime);
        firstTrial = false;
    end
end

% keep fixation spot after stimulus turns off
if ~abort

    drawFixSpot(e);
    e = swap(e);

    % log stimulus offset event
    e = addEvent(e,'endStimulus',getLastSwap(e));

    stimTime = getParam(e,'stimulusTime');
    postStimTime = getParam(e,'postStimulusTime');
    while (GetSecs-startTime)*1000 < (stimTime + postStimTime);
        % check for abort signal
        [e,abort] = tcpMiniListener(e,{'netAbortTrial','netTrialOutcome'});
        if abort
            break
        end
    end
    
    if ~abort
        e = clearScreen(e);
    end
else
    % log stimulus offset event
    e = addEvent(e,'endStimulus',getLastSwap(e));
end

% save bar locations
e = setTrialParam(e,'barLocations',s);
e = setTrialParam(e,'barRects',rect);
e = setTrialParam(e,'barCenters',center);
