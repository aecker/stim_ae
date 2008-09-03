function e = showFlashedBar(e,varargin)
% Flashed bar for Flash-Lag effect electrophysiology.
% AE 2008-09-03

% parameters
barSize    = getParam(e,'barSize');
dx         = getParam(e,'dx');
stimCenter = getParam(e,'stimCenter');
trajAngle  = getParam(e,'trajectoryAngle');
trajLen    = getParam(e,'trajectoryLength');
nLocs      = getParam(e,'numFlashLocs');
loc        = getParam(e,'flashLocation');

% determine number of frames
nFrames = ceil(trajLen / dx);
if mod(nFrames,2) ~= mod(nLocs,2)
    nFrames = nFrames - 1;
end

% determine starting position (this way we make sure it will hit the flash 
% locations)
angle = trajAngle / 180 * pi;
flashLoc = (loc - (nLocs + 1) / 2) * barSize(1);
flashFrame = ceil(rand(1) * nFrames);

abort = false;
firstTrial = true;
rect = [];
center = [];
for i = 1:flashFrame
    
    % check for abort signal
    [e,abort] = tcpMiniListener(e,{'netAbortTrial','netTrialOutcome'});
    if abort
        break
    end

    % draw flashed bar
    if i == flashFrame
        center = stimCenter + flashLoc * [cos(angle); -sin(angle)];
        rect = [center - barSize/2; center + barSize/2];
        Screen('DrawTexture',get(e,'win'),e.tex,[],rect,-angle*180/pi); 
    end
    
    % fixation spot
    drawFixSpot(e);

    % buffer swap
    e = swap(e);
    
    % log stimulus onset time (defined in this case as time of the flash)
    if i == flashFrame
        e = addEvent(e,'showStimulus',getLastSwap(e));
    end
    
    % log start time
    if firstTrial
        startTime = getLastSwap(e);
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
    while (GetSecs - startTime) * 1000 < (stimTime + postStimTime);
        % check for abort signal
        [e,abort] = tcpMiniListener(e,{'netAbortTrial','netTrialOutcome'});
        if abort
            break
        end
    end
    
    if ~abort
        e = clearScreen(e);
    end
end

% save bar locations
e = setTrialParam(e,'barLocations',flashLoc);
e = setTrialParam(e,'barRects',rect);
e = setTrialParam(e,'barCenters',center);
e = setTrialParam(e,'flashFrame',flashFrame');
