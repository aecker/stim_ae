function [e,abort,startTime] = showMovingBar(e,cond,firstStim)
% FLE ephys stimulus: moving bar/combined moving+flash.
% AE 2009-08-16
% MS 2012-01-16, 2012-04-18, 2012-08-14
% parameters
conditions  = getConditions(get(e,'randomization'));
isFlash     = conditions(cond).isFlash;
isStop      = conditions(cond).isStop;
isInit      = conditions(cond).isInit;
trajAngle   = conditions(cond).trajectoryAngle;
dir         = conditions(cond).direction;
dx          = conditions(cond).dx;
loc         = conditions(cond).flashLocation;
arrangement = conditions(cond).arrangement;
trajOffset  = conditions(cond).trajOffset;
locDist     = getParam(e,'flashLocDistance');
vDist       = getParam(e,'verticalDistance');
barSize     = getParam(e,'barSize');
stimCenter  = getParam(e,'stimCenter');
trajLen     = getParam(e,'trajectoryLength');
nLocs       = getParam(e,'numFlashLocs');
combined    = getParam(e,'combined');


% assert( mod(nLocs,2) || (~combined && ~(isInit || isStop)),...
%     'When using combined stimulus or flashInitiated and/or flashTerminated conditions, the number of flash locations has to be odd!')

% MS 2012-04-18 - always keep odd number of flash locations
assert( logical(mod(nLocs,2)), 'The number of flash locations has to be odd!')


% stimulus arrangement: which one goes through the center (i.e. the RFs)
vDistMov = arrangement * vDist;
vDistFlash = (1 - arrangement) * vDist;

% determine number of frames - AE
% trajFrames = ceil(trajLen / dx);
% trajFrames = trajFrames - (mod(trajFrames,2) ~= mod(nLocs,2))
% centerFrame = (trajFrames + 1) / 2

% determine number of frames - MS - modified the above code so that the actual trajectory
% length is >= getParam(e,'trajectoryLength'). The code above creates trajectoryLength <= 
% getParam(e,'trajectoryLength').
half_traj_steps = ceil(trajLen/2/dx);
trajFrames = length([-half_traj_steps:0 1:half_traj_steps]);
% centerFrame = (trajFrames + 1) / 2;

% flash-stop or flash-init condition?
if isStop || isInit
%     if combined
%         % combined stimulus: stop is always at the center of the screen 
%         % with the flash at a given offset
%         nFrames = centerFrame;
%     else
        % individual stimuli: start or stop at each of the flash locations
%         relFlashDist = (loc - (nLocs + 1) / 2) * locDist;
%         flipSign = ((-1)^dir)*((-1)^isStop);
%         pixToMove = (trajFrames * dx/2) - flipSign * relFlashDist;
% Trajectory length for initiated and terminated conditions is half of the continuous
% motion trajectory length.
        pixToMove = round(trajFrames * dx/2);
        nFrames = ceil(pixToMove/dx);        
%     end
else
    nFrames = trajFrames;
end

% Determine starting position (to make sure we hit the flash locations)
angle = trajAngle / 180 * pi;
startPos = trajOffset + (-(trajFrames - 1) / 2 * dx);

if isInit
    if combined
        % For flash initiated combined condition, the moving bar always starts from the
        % trajectory center irrespective of the flash location.
        error('Flash init condition not implemented yet for combined condition')
%         startPos = 0;        
    else
        % For flash initiated single condition, the moving bar starts from each flash location.
        startPos = (loc - (nLocs + 1) / 2) * locDist;
    end
end

if isStop
    if combined
        error('Flash stop condition not implemented yet for combined condition')
    else
        stopPos = (loc -  (nLocs + 1)/2) * locDist;
        startPos = stopPos - ((-1)^(dir) * (nFrames-1) * locDist);
    end
end
% combined? determine flash location
if isFlash
    % Distance of flash center in pix relative to stim center
    flashLoc = (loc - (nLocs + 1) / 2) * locDist;
    
    flashCenter = stimCenter + [0; vDistFlash] + flashLoc * [cos(angle); -sin(angle)];
    flashRect = [flashCenter - barSize/2; flashCenter + barSize/2];
else
    flashLoc = [];
    flashCenter = [];
    flashRect = [];
end

    
abort = false;
startTime = NaN;
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
    if (isInit || isStop) && ~combined
        s(i) = startPos + (i-1) * dx * (-1)^dir;
    else
        s(i) = (-1)^dir * (startPos + (i-1) * dx);
    end
    
    
    center(:,i) = stimCenter + [0; vDistMov] + s(i) * [cos(angle); -sin(angle)];
    rect(:,i) = [center(:,i) - barSize/2; center(:,i) + barSize/2];
    Screen('DrawTexture',get(e,'win'),e.tex(cond),[],rect(:,i),-angle*180/pi); 
   
    % combined? center frame: flash
    
%     if isFlash && ((isInit && i==1) || (~isInit && i == centerFrame))
%         Screen('DrawTexture',get(e,'win'),e.tex(cond),[],flashRect,-angle*180/pi);
%     end

    % In combined condition, we show the flash and moving bar with zero
    % offset only. And we will do this for each flash location - MS
    if isFlash && ((isInit && i==1) || (~isInit && center(1,i)==flashCenter(1)))
        Screen('DrawTexture',get(e,'win'),e.tex(cond),[],flashRect,-angle*180/pi);
    end
    
    % fixation spot
    drawFixSpot(e);

    % buffer swap
    e = swap(e);
    
    if i == 1
        % in case this is the first stimulus in this trial, put showStim event
        startTime = getLastSwap(e);
        if firstStim
            e = addEvent(e,'showStimulus',startTime);
        end
        
        % log start time for this sub stimulus
        e = addEvent(e,'showSubStimulus',startTime,cond);
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
