function [e,abort] = showMovingBar(e,cond,firstStim)
% Moving bar for Flash-Lag effect electrophysiology.
% AE 2009-03-16

% parameters
conditions = getConditions(get(e,'randomization'));
trajAngle  = conditions(cond).trajectoryAngle;
dir        = conditions(cond).direction;
dx         = conditions(cond).dx;
isStop     = conditions(cond).isStop;
barSize    = getParam(e,'barSize');
stimCenter = getParam(e,'stimCenter');
trajLen    = getParam(e,'trajectoryLength');
nLocs      = getParam(e,'numFlashLocs');

% determine number of frames
trajFrames = ceil(trajLen / dx);
trajFrames = trajFrames - (mod(trajFrames,2) ~= mod(nLocs,2));

% determine starting position (to make sure we hit the flash locations)
angle = trajAngle / 180 * pi;
startPos = -(trajFrames - 1) / 2 * dx;

% flash-stop condition?
if isStop
    loc = conditions(cond).flashLocation;
    if ~dir
        nFrames = (trajFrames - nLocs) / 2 + loc;
    else
        nFrames = (trajFrames - nLocs) / 2 + (nLocs - loc + 1);
    end
else
    nFrames = trajFrames;
end
    
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
    Screen('DrawTexture',get(e,'win'),e.tex(cond),[],rect(:,i),-angle*180/pi); 
    
    % fixation spot
    drawFixSpot(e);

    % buffer swap
    e = swap(e);
    
    if i == 1
        % in case this is the first stimulus in this trial, put showStim event
        swapTime = getLastSwap(e);
        if firstStim
            e = addEvent(e,'showStimulus',swapTime);
        end
        
        % log start time for this sub stimulus
        e = addEvent(e,'showSubStimulus',swapTime,cond);
    end
    
end

if ~abort
    % remove bar but keep fixation spot
    drawFixSpot(e);
    e = swap(e);
end

% save bar locations
e = setTrialParam(e,'barLocations',[getParam(e,'barLocations') {s}]);
e = setTrialParam(e,'barRects',[getParam(e,'barRects') {rect}]);
e = setTrialParam(e,'barCenters',[getParam(e,'barCenters') {center}]);
