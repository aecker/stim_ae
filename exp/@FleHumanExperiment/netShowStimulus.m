function [e,retInt32,retStruct,returned] = netShowStimulus(e,params) %#ok<INUSD>
% Show stimulus.
% AE 2007-10-17

% some member variables..
win     = get(e,'win');
refresh = get(e,'refreshRate');

% parameters
barSize          = getParam(e,'barSize');
len              = getParam(e,'trajectoryLength');
speed            = getParam(e,'speed');
flashDuration    = getParam(e,'flashDuration');
perceivedLag     = getParam(e,'perceivedLag');
flashLoc         = getParam(e,'flashLocation');
flashOffset      = getParam(e,'flashOffset');
trajectoryAngle  = getParam(e,'trajectoryAngle');
trajectoryCenter = getParam(e,'trajectoryCenter');
moveDir          = getParam(e,'direction');
cond             = getParam(e,'condition');

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

% compute location of moving bar at time of flash
movingLoc = flashLoc - offsetX;
e = setTrialParam(e,'movingLocation',movingLoc);
fprintf('flashLocation: %d  movingLocation: %d   offset: %d\n',flashLoc,movingLoc,flashOffset)

% put start time
firstTrial = true;
n = ceil(len / speed * refresh);
s = zeros(n,1);
pos = startPos;
i = 1;
flash = 0;
while s(i) < len

    % draw colored rectangle
    rect = [pos - barSize/2; pos + barSize/2];
    Screen('DrawTexture',win,e.tex(cond),[],rect,-angle*180/pi); 
    
    % draw flashing bar
    if flash > 0
        if flash == flashDuration
            flashRect = [pos + offset - barSize/2; pos + offset + barSize/2];
            e = setTrialParam(e,'flashRect',flashRect);
        end
        Screen('DrawTexture',win,e.tex(cond),[],flashRect,-angle*180/pi); 
        flash = flash - 1;
    end

    % buffer swap
    drawFixSpot(e);
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

e = clearScreen(e);

% save bar locations
e = setTrialParam(e,'barLocations',s(1:i-1));

% return values
retInt32 = int32(0);
returned = true;
