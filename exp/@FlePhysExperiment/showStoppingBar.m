function e = showStoppingBar(e,varargin)
% Stopping bar for Flash-Lag effect electrophysiology.
% AE 2008-09-16

% parameters
barSize    = getParam(e,'barSize');
dx         = getParam(e,'dx');
stimCenter = getParam(e,'stimCenter');
trajAngle  = getParam(e,'trajectoryAngle');
loc        = getParam(e,'flashLocation');
nLocs      = getParam(e,'numFlashLocs');
dir        = getParam(e,'direction');         % \in {0,1}
cond       = getParam(e,'condition');
nFrames    = getParam(e,'nFrames');

% determine starting position (this way we make sure it will hit the flash 
% locations)
angle = trajAngle / 180 * pi;
startPos = -(nFrames - 1) / 2 * dx;
if ~dir
    flashFrame = (nFrames - nLocs) / 2 + loc;
else
    flashFrame = (nFrames - nLocs) / 2 + (nLocs - loc + 1);
end    

firstTrial = true;
abort = false;
s = zeros(1,nFrames);
rect = zeros(4,nFrames);
center = zeros(2,nFrames);

% return function call
tcpReturnFunctionCall(e,int32(0),struct,'netShowStimulus');

for i = 1:flashFrame
    
    % check for abort signal
    [e,abort] = tcpMiniListener(e,{'netAbortTrial','netTrialOutcome'});
    if abort
        break
    end

    % draw colored rectangle
    s(i) = (-1)^dir * (startPos + (i-1) * dx);
    center(:,i) = stimCenter + s(i) * [cos(angle); -sin(angle)];
    rect(:,i) = [center(:,i) - barSize/2; center(:,i) + barSize/2];
    Screen('DrawTexture',get(e,'win'),e.tex(cond),[],rect(:,i),-angle*180/pi); 
    
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
e = setTrialParam(e,'flashFrame',flashFrame');
