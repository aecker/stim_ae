function [e,retInt32,retStruct,returned] = netStartTrial(e,params)
% Start a new trial.
% AE & MS

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

% call parent's initTrial
[e,retInt32,retStruct,returned] = initTrial(e,params);

% target information needs to go back to LabView
targetLocation = getParam(e,'targetLocation');
monitorCenter = getParam(e,'monitorCenter');
leftTarget = monitorCenter + targetLocation;
rightTarget = monitorCenter + targetLocation .* [-1; 1];
e = setTrialParam(e,'leftTarget',leftTarget);
e = setTrialParam(e,'rightTarget',rightTarget);

retStruct.leftTarget =  targetLocation;
retStruct.rightTarget = targetLocation .* [-1; 1];
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
relDelayTime    = getParam(e,'relDelayTime');
% pick random direction of motion
moveDir = rand(1) > getParam(e,'moveProb');


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


% (1) We want the offset to be relative to the average location of the moving
%     bar. Since the exact flash location is calculated when the flash starts
%     we need to adjust the offset by the expected number of pixels the bar
%     moves during the flash. This is #(frames-1)*flashDuration
% (2) In order to make the offsets appear approximately symmetric during
%     training, we compensate for the perceived lag.
% (3) Positive offset means the flashed bar is ahead of the moving bar

offsetMove = (flashDuration - 1) * speed / refresh / 2;
xOffset = flashOffset + offsetMove + perceivedLag;


% in training, we allow randomized and fixed locations. in the experiment,
% we give it a number of locations at which the flash may be shown
if expMode == FlashLagExperiment.TRAINING
    if randLocation
        movingLoc = noFlashZone + abs(flashOffset) * (flashOffset < 0) ...
            + rand(1) * ...
            (len - abs(flashOffset) - 2 * (noFlashZone + offsetMove) - perceivedLag);
        flashLoc = movingLoc + xOffset;
        
        % flashLoc = rand(1)*(len-2*abs(flashOffset)) + (flashOffset > 0)*2*abs(flashOffset);
        movingLoc = flashLoc - flashOffset;
    else
        movingLoc = flashLoc - xOffset;
    end
else
    ndx = ceil(rand*length(flashLocMult));
    flashLoc = flashLocMult(ndx);
    movingLoc = flashLoc - xOffset;
end

% Punish according to user specification during training mode only
punishTime = 0;
if ~expMode
    d = get(e,'data');
    correctResp = getPrev(d,'correctResponse');
    validTrial = getPrev(d,'validTrial');
    
    fprintf('cr: %s\n',num2str(correctResp));
    fprintf('vt: %s\n',num2str(validTrial));
    
    if ~isnan(validTrial) && ~isnan(correctResp)
        inCorrectResponse = ~correctResp;
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
        crt = params.condRepeatType;
        if (strcmp(crt,'IncorrRespOnly')&& validTrial && inCorrectResponse) ||...
                (strcmp(crt,'AbortsOnly')&& ~validTrial) || ...
                (strcmp(crt,'IncorrRespAndAborts')&&(~validTrial || inCorrectResponse))
            
            flashLoc = getPrev(d,'flashLocation');
            movingLoc = getPrev(d,'movingLocation');
            flashOffset = getPrev(d,'flashOffset');
            xOffset = getPrev(d,'xOffset');
            moveDir = getPrev(d,'moveDir');
        end
    end
end
e = setTrialParam(e,'flashLocation',flashLoc);
e = setTrialParam(e,'movingLocation',movingLoc);
e = setTrialParam(e,'flashOffset',flashOffset);
e = setTrialParam(e,'xOffset',xOffset);
e = setTrialParam(e,'moveDir',moveDir);
e = setTrialParam(e,'stimulusTime',len / speed * 1000);



% determine delay time (is specified relative to time of flash)

% delayTime is now set by matlab for this experiment. Labview will simply
% display the delayTime -MS 2011-12-12

% if getParam(e,'delayTime') < 0
    flashTime = movingLoc / speed * 1000;
    delayTime = flashTime + relDelayTime;
    e = setTrialParam(e,'delayTime',delayTime);
    retStruct.delayTime = delayTime;
% end



fprintf('flashLocation: %d | movingLocation: %d | offset: %d\n', ....
    round(flashLoc),round(movingLoc),flashOffset)

retStruct.punishTime = int32(punishTime);

