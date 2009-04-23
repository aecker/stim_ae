function [e,abort] = showFlashedBar(e,cond,firstStim)
% Flashed bar for Flash-Lag effect electrophysiology.
% AE 2009-03-16

% parameters
conditions = getConditions(get(e,'randomization'));
trajAngle  = conditions(cond).trajectoryAngle;
loc        = conditions(cond).flashLocation;
barSize    = getParam(e,'barSize');
stimCenter = getParam(e,'stimCenter');
nLocs      = getParam(e,'numFlashLocs');

% draw flashed bar
angle = trajAngle / 180 * pi;
flashLoc = (loc - (nLocs + 1) / 2) * barSize(1);
center = stimCenter + flashLoc * [cos(angle); -sin(angle)];
rect = [center - barSize/2; center + barSize/2];
Screen('DrawTexture',get(e,'win'),e.tex(cond),[],rect,-angle*180/pi);

% fixation spot
drawFixSpot(e);

% buffer swap
e = swap(e);
startTime = getLastSwap(e);

% in case this is the first stimulus in this trial, put showStim event
if firstStim
    e = addEvent(e,'showStimulus',startTime);
end

% log start time
e = addEvent(e,'showSubStimulus',startTime,cond);

% remove bar immediately at the next frame
drawFixSpot(e);
e = swap(e);

% save bar locations
e = setTrialParam(e,'barLocations',[getParam(e,'barLocations') {flashLoc}]);
e = setTrialParam(e,'barRects',[getParam(e,'barRects') {rect}]);
e = setTrialParam(e,'barCenters',[getParam(e,'barCenters') {center}]);

% this function only takes two frames, so we don't bother about checking for
% aborts in here
abort = false;
