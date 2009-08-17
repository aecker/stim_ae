function [e,abort] = showMovingBar(e,cond,firstStim)
% FLE ephys stimulus: moving bar/combined moving+flash.
% AE 2009-08-16

% parameters
conditions  = getConditions(get(e,'randomization'));
isFlash     = conditions(cond).isFlash;
isStop      = conditions(cond).isStop;
trajAngle   = conditions(cond).trajectoryAngle;
dir         = conditions(cond).direction;
dx          = conditions(cond).dx;
loc         = conditions(cond).flashLocation;
arrangement = conditions(cond).arrangement;
locDist     = getParam(e,'flashLocDist');
vDist       = getParam(e,'verticalDistance');
barSize     = getParam(e,'barSize');
stimCenter  = getParam(e,'stimCenter');
trajLen     = getParam(e,'trajectoryLength');
nLocs       = getParam(e,'numFlashLocs');

% stimulus arrangement: which one goes through the center (i.e. the RFs)
vDistMov = arrangement * vDist;
vDistFlash = (1 - arrangement) * vDist;

% determine number of frames
trajFrames = ceil(trajLen / dx);
trajFrames = trajFrames - (mod(trajFrames,2) ~= mod(nLocs,2));

% determine starting position (to make sure we hit the flash locations)
angle = trajAngle / 180 * pi;
startPos = -(trajFrames - 1) / 2 * dx;

% combined? determine flash location
if isFlash
    flashLoc = (loc - (nLocs + 1) / 2) * locDist;
    flashCenter = stimCenter + flashLoc * [cos(angle); -sin(angle)];
    flashRect = [flashCenter - barSize/2; flashCenter + vDistFlash + barSize/2];
    centerFrame = (trajFrames + 1) / 2;
else
    flashLoc = [];
    flashCenter = [];
    flashRect = [];
end

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
    center(:,i) = stimCenter + [0; vDistMov] + s(i) * [cos(angle); -sin(angle)];
    rect(:,i) = [center(:,i) - barSize/2; center(:,i) + barSize/2];
    Screen('DrawTexture',get(e,'win'),e.tex(cond),[],rect(:,i),-angle*180/pi); 
    
    % combined? center frame: flash
    if isFlash && i == centerFrame
        Screen('DrawTexture',get(e,'win'),e.tex(cond),[],flashRect,-angle*180/pi);
    end
    
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

e = setTrialParam(e,'flashLocations',[getParam(e,'flashLocations') {flashLoc}]);
e = setTrialParam(e,'flashRects',[getParam(e,'flashRects') {flashRect}]);
e = setTrialParam(e,'flashCenters',[getParam(e,'flashCenters') {flashCenter}]);
