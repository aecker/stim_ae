function [e,retInt32,retStruct,returned] = netStartTrial(e,params)
% Start a new trial.

% check if maxBlockSize has changed
r = get(e,'randomization');
if isfield(params,'maxBlockSize') && params.maxBlockSize ~= getMaxBlockSize(r)
    r = setMaxBlockSize(r,params.maxBlockSize);
    data = get(e,'data');
    data = setConditions(data,getConditions(r));
    e = set(e,'data',data);
end

% check if expMode has changed
if isfield(params,'expMode') && params.expMode ~= isExpMode(r)
    r = setExpMode(r,params.expMode);
end
e = set(e,'randomization',r);

% call parent's netStartTrial
[e,retInt32,retStruct,returned] = initTrial(e,params);

% target information needs to go back to LabView
targetLocation = getParam(e,'targetLocation');
monitorCenter = getParam(e,'monitorCenter');
leftTarget = monitorCenter + targetLocation;
rightTarget = monitorCenter + targetLocation .* [-1; 1];
e = setTrialParam(e,'leftTarget',leftTarget);
e = setTrialParam(e,'rightTarget',rightTarget);
retStruct.leftTarget = leftTarget;
retStruct.rightTarget = rightTarget;
retStruct.targetRadius = getParam(e,'targetRadius');

len             = getParam(e,'trajectoryLength');
speed           = getParam(e,'speed');
flashLoc        = getParam(e,'flashLocation'); % constant location for training
flashLocMult    = getParam(e,'flashLocations'); % variable locations for experiment (used with expmode)
randLocation    = getParam(e,'randLocation');
noFlashZone     = getParam(e,'noFlashZone');
flashDuration   = getParam(e,'flashDuration');
perceivedLag    = getParam(e,'perceivedLag');
lagProb         = getParam(e,'lagProb');
expMode         = getParam(e,'expMode');       % expMode=true means we use the fixed flashOffsets
flashOffset     = getParam(e,'flashOffset');   % constant offset for training  
flashOffsets    = getParam(e,'flashOffsets');  % different offsets used for experiment
offsetThreshold = getParam(e,'offsetThreshold');
trialType       = getParam(e,'trialType');
refresh         = get(e,'refreshRate');

% pick random direction of motion
moveDir = rand(1) > getParam(e,'moveProb');
e = setTrialParam(e,'moveDir',moveDir);
e = setTrialParam(e,'stimulusTime',len / speed * 1000);

% For training we use a fixed offset (flashOffset) set on the front panel. For
% the experiment we use a fixed set of offsets (flashOffsets) defined in the
% config file
if expMode == FlashLagExperiment.TRAINING
    lagDir = 2 * (rand(1) > lagProb) - 1;
    flashOffset = lagDir * flashOffset;

else % if expMode == FlashLagExperiment.EXPERIMENT
    if trialType == ReportPerceptRandomization.PROBE
        offsets = find(abs(flashOffsets) <= offsetThreshold);
    else % if trialType == ReportPerceptRandomization.REGULAR_[NO_]REWARD
        offsets = find(abs(flashOffsets) > offsetThreshold);
    end
    ndx = offsets(ceil(rand(1) * length(offsets)));
    flashOffset = flashOffsets(ndx);
end
e = setTrialParam(e,'flashOffset',flashOffset);

% The response should indicate the location of the flashed bar relative to the 
% moving bar
if flashOffset < 0 && moveDir == FlashLagExperiment.MOTION_LEFT || ...
        flashOffset >= 0 && moveDir == FlashLagExperiment.MOTION_RIGHT
    retStruct.correctResponse = int32(TrialBasedExperiment.RIGHT_JOYSTICK);
    disp('correct response: right')
else
    retStruct.correctResponse = int32(TrialBasedExperiment.LEFT_JOYSTICK);
    disp('correct response: left')
end

% (1) We want the offset to be relative to the average location of the moving
%     bar. Since the exact flash location is calculated when the flash starts
%     we need to adjust the offset by the expected number of pixels the bar
%     moves during the flash. This is #(frames-1)*flashDuration
% (2) In order to make the offsets appear approximately symmetric during
%     training, we compensate for the perceived lag.
% (3) Positive offset means the flashed bar is ahead of the moving bar
offsetMove = (flashDuration - 1) * speed / refresh / 2;
xOffset = flashOffset + offsetMove + perceivedLag;
e = setTrialParam(e,'xOffset',xOffset);

% in training, we allow randomized and fixed locations. in the experiment,
% we give it a number of locations at which the flash may be shown
if expMode == FlashLagExperiment.TRAINING
    if randLocation
        movingLoc = noFlashZone + abs(flashOffset) * (flashOffset < 0) ...
            + rand(1) * ...
                (len - abs(flashOffset) - 2 * (noFlashZone + offsetMove) - perceivedLag);
        flashLoc = movingLoc + xOffset;
    else
        movingLoc = flashLoc - xOffset;
    end
else
    ndx = ceil(rand*length(flashLocMult));
    flashLoc = flashLocMult(ndx);
    movingLoc = flashLoc - xOffset;
end
e = setTrialParam(e,'flashLocation',flashLoc);
e = setTrialParam(e,'movingLocation',movingLoc);

fprintf('flashLocation: %d | movingLocation: %d | offset: %d\n', ....
    round(flashLoc),round(movingLoc),flashOffset)

% determine delay time (is specified relative to time of flash)
relDelayTime = getParam(e,'delayTime');
flashTime = movingLoc / speed * 1000;
delayTime = flashTime + relDelayTime;
e = setTrialParam(e,'relDelayTime',relDelayTime);
e = setTrialParam(e,'delayTime',delayTime);
retStruct.delayTime = delayTime;

% Punish according to user specification
inCorrectResponse = ~(getParam(e,'correctResponse'));
validTrial = getParam(e,'validTrial');
punishTime = 0;
switch params.punishType
    case 'IncorrRespOnly'
        if validTrial && inCorrectResponse
            punishTime = params.punishTime;
        end
    case 'AbortsOnly'
        if ~validTrial
            punishTime = params.punishTime;
        end
    otherwise % aborts and incorrect response
        if ~validTrial || inCorrectResponse
            punishTime = params.punishTime;
        end
end
retStruct.punishTime = int32(punishTime);

