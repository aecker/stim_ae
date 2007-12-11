function [e,retInt32,retStruct,returned] = netShowStimulus(e,params)
% Show stimulus.
% AE 2007-10-17

% some member variables..
win     = get(e,'win');
refresh = get(e,'refreshRate');
rnd     = get(e,'randomization');

% parameters
barSize          = getParam(e,'barSize');
len              = getParam(e,'trajectoryLength');
speed            = getParam(e,'speed');
flashDuration    = getParam(e,'flashDuration');
perceivedLag     = getParam(e,'perceivedLag');
flashLoc         = getParam(e,'flashLocation');
randLocation     = getParam(e,'randLocation');
noFlashZone      = getParam(e,'noFlashZone');
lagProb          = getParam(e,'lagProb');
expMode          = getParam(e,'expMode');       % expMode=true means we use the fixed flashOffsets
flashOffset      = getParam(e,'flashOffset');   % constant offset for training  
flashOffsets     = getParam(e,'flashOffsets');  % different offsets used for experiment
offsetThreshold  = getParam(e,'offsetThreshold');
trialType        = getParam(e,'trialType');
trajectoryAngle  = getParam(e,'trajectoryAngle');
trajectoryCenter = getParam(e,'trajectoryCenter');
moveDir = rand(1) > getParam(e,'moveProb');
e = setTrialParam(e,'moveDir',moveDir);

% For training we use a fixed offset (flashOffset) set on the front panel. For
% the experiment we use a fixed set of offsets (flashOffsets) defined in the
% config file
if expMode == TRAINING(e)
    lagDir = 2 * (rand(1) > lagProb) - 1;
    flashOffset = lagDir * flashOffset;

else % if expMode == EXPERIMENT(e)
    if trialType == PROBE(rnd)
        offsets = find(abs(flashOffsets) <= offsetThreshold);
    else % if trialType == REGULAR_[NO_]REWARD(rnd)
        offsets = find(abs(flashOffsets) > offsetThreshold);
    end
    ndx = offsets(ceil(rand(1) * length(offsets)));
    flashOffset = flashOffsets(ndx);
end
e = setTrialParam(e,'flashOffset',flashOffset);

% The response should indicate the location of the flashed bar relative to the 
% moving bar
if flashOffset < 0 && moveDir == MOTION_LEFT(e) || ...
        flashOffset >= 0 && moveDir == MOTION_RIGHT(e)
    retStruct.correctResponse = RIGHT_JOYSTICK(e);
    disp('correct response: right')
else
    retStruct.correctResponse = LEFT_JOYSTICK(e);
    disp('correct response: left')
end
retStruct.trialIndex = int32(getParam(e,'trialIndex'));
retStruct.trialType = int32(getParam(e,'trialType'));
retStruct.blockSize = int32(getParam(e,'blockSize'));
retStruct.blockType = int32(getParam(e,'blockType'));
% as this is a non-blocking function call from LabView, we have to return it
% manually
tcpReturnFunctionCall(e,int32(0),retStruct);

% determine starting position
angle = (trajectoryAngle + 180 * moveDir) / 180 * pi;
startPos = trajectoryCenter - len/2 * [cos(angle); -sin(angle)];

% (1) We want the offset to be relative to the average location of the moving
%     bar. Since the exact flash location is calculated when the flash starts
%     we need to adjust the offset by the expected number of pixels the bar
%     moves during the flash. This is #(frames-1)*flashDuration
% (2) In order to make the offsets appear approximately symmetric during
%     training, we compensate for the perceived lag.
% (3) Positive offset means the flashed bar is ahead of the moving bar
offsetMove = (flashDuration - 1) * speed / refresh / 2;
offsetX = flashOffset + offsetMove + perceivedLag;
offsetY = 1.2 * barSize(2);
offset = offsetX * [cos(angle); -sin(angle)] ...
       + offsetY * [sin(mod(angle,pi)); cos(mod(angle,pi))];

% is flash location randomized?
if randLocation
    movingLoc = noFlashZone + abs(flashOffset) * (flashOffset < 0) ...
        + rand(1) * ...
            (len - abs(flashOffset) - 2 * (noFlashZone + offsetMove) - perceivedLag);
    flashLoc = movingLoc + offsetX;
else
    movingLoc = flashLoc - offsetX;
end
e = setTrialParam(e,'flashLocation',flashLoc);
e = setTrialParam(e,'movingLocation',movingLoc);

% put start time
firstTrial = true;
n = ceil(len / speed * refresh);
s = zeros(n,1);
pos = startPos;
i = 1;
abort = false;
flash = 0;
while s(i) < len

	% Does the monkey have to fixate?
    if getParam(e,'fixationMode')
     	drawFixSpot(e);
    end

    % check for abort signal
    [e,abort] = tcpMiniListener(e,{'netAbortTrial','netTrialOutcome'});
    if abort
        break
    end

    % draw colored rectangle
    rect = [pos - barSize/2; pos + barSize/2];
    Screen('DrawTexture',win,e.tex,[],rect,-angle*180/pi); 
    
    % draw flashing bar
    if flash > 0
        if flash == flashDuration
            flashRect = [pos + offset - barSize/2; pos + offset + barSize/2];
            e = setTrialParam(e,'flashRect',flashRect);
        end
        Screen('DrawTexture',win,e.tex,[],flashRect,-angle*180/pi); 
        flash = flash - 1;
    end

    % buffer swap
    e = swap(e);
    
    % compute timeout
    if firstTrial
        startTime = getLastSwap(e);
        e = addEvent(e,'showStimulus',startTime);
        firstTrial = false;
    end

    i = i+1;
    
    % compute next position
    s(i) = (getLastSwap(e) - startTime + 1 / refresh) * speed;
    pos = startPos + s(i) * [cos(angle); -sin(angle)];
    
    % flash?
    if s(i-1) < movingLoc && s(i) >= movingLoc
        flash = flashDuration;
    end    
end

% keep fixation spot after stimulus turns off
if ~abort

    % Does the monkey have to fixate?
    if getParam(e,'fixationMode')
        drawFixSpot(e);
        e = swap(e);
        delayTime = getParam(e,'delayTime');
        responseTime = getParam(e,'responseTime');
        
        % wait until response time is over, then remove fixation spot
        while GetSecs < startTime + delayTime + responseTime
            % check for abort signal
            [e,abort] = tcpMiniListener(e,{'netAbortTrial','netTrialOutcome'});
            if abort
                break
            end
        end
    end
    
    if ~abort
        e = clearScreen(e);
    end
end

% save bar locations
e = setTrialParam(e,'barLocations',s(1:i-1));

% return values
retInt32 = int32(0);
retStruct = struct;
returned = true;
