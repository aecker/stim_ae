function [e,abort,startTime] = showFlashedBar(e,cond,firstStim)
% Flashed bar for Flash-Lag effect electrophysiology.
% AE 2009-03-16
% MS 2012-08-15
% parameters
conditions  = getConditions(get(e,'randomization'));
trajAngle   = conditions(cond).trajectoryAngle;
loc         = conditions(cond).flashLocation;
arrangement = conditions(cond).arrangement;
locDist     = getParam(e,'flashLocDistance');
barSize     = getParam(e,'barSize');
stimCenter  = getParam(e,'stimCenter');
nLocs       = getParam(e,'numFlashLocs');
vDist       = getParam(e,'verticalDistance');
nLocsBarMap       = getParam(e,'numFlashLocsBarMap');

isInit = getParam(e,'flashInit');
isStop = getParam(e,'flashStop');
if isInit || isStop
    nLocs = nLocsBarMap;
end
% stimulus arrangement: which one goes through the center (i.e. the RFs)
vDistFlash = (1 - arrangement) * vDist;

% draw flashed bar
angle = trajAngle / 180 * pi;
flashLoc = (loc - (nLocs + 1) / 2) * locDist;
center = stimCenter + [0; vDistFlash] + flashLoc * [cos(angle); -sin(angle)];
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
e = setTrialParam(e,'flashLocations',[getParam(e,'flashLocations') {flashLoc}]);
e = setTrialParam(e,'flashgRects',[getParam(e,'flashRects') {rect}]);
e = setTrialParam(e,'flashCenters',[getParam(e,'flashCenters') {center}]);

e = setTrialParam(e,'barLocations',[getParam(e,'barLocations') {[]}]);
e = setTrialParam(e,'barRects',[getParam(e,'barRects') {[]}]);
e = setTrialParam(e,'barCenters',[getParam(e,'barCenters') {[]}]);

% this function only takes two frames, so we don't bother about checking for
% aborts in here
abort = false;
