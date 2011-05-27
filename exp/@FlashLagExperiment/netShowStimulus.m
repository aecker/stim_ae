function [e,retInt32,retStruct,returned] = netShowStimulus(e,varargin)
% Show stimulus.
% AE 2007-10-17

% as this is a non-blocking function call from LabView, we have to return it
% manually
retStruct.trialIndex = int32(getParam(e,'trialIndex'));
retStruct.trialType = int32(getParam(e,'trialType'));
retStruct.blockSize = int32(getParam(e,'blockSize'));
retStruct.blockType = int32(getParam(e,'blockType'));
tcpReturnFunctionCall(e,int32(0),retStruct);

% some member variables..
win     = get(e,'win');
refresh = get(e,'refreshRate');

% parameters
barSize          = getParam(e,'barSize');
len              = getParam(e,'trajectoryLength');
speed            = getParam(e,'speed');
flashDuration    = getParam(e,'flashDuration');
xOffset          = getParam(e,'xOffset');
yOffset          = getParam(e,'yOffset');
trajectoryAngle  = getParam(e,'trajectoryAngle');
trajectoryCenter = getParam(e,'trajectoryCenter');
moveDir          = getParam(e,'moveDir');
movingLoc        = getParam(e,'movingLoc');
leftTarget       = getParam(e,'leftTarget');
rightTarget      = getParam(e,'rightTarget');
targetRadius     = getParam(e,'targetRadius');
targetColor      = getParam(e,'targetColor');

% determine starting position
angle = (trajectoryAngle + 180 * moveDir) / 180 * pi;
startPos = trajectoryCenter - len/2 * [cos(angle); -sin(angle)];

% AE 2010-10-23: Changed the vertical offset to be a parameter
% yOffset = 1.2 * barSize(2);
offset = xOffset * [cos(angle); -sin(angle)] ...
       + yOffset * [sin(mod(angle,pi)); cos(mod(angle,pi))];

% put start time
firstTrial = true;
n = ceil(len / speed * refresh);
s = zeros(n,1);
pos = startPos;
i = 1;
abort = false;
flash = 0;
while s(i) < len

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

    % fixation spot
    drawFixSpot(e);
    
    % response targets
    Screen('DrawDots',win,[leftTarget rightTarget],targetRadius/2,targetColor',[],1);
    
    % buffer swap
    e = swap(e);
    
    % compute timeout
    if firstTrial
        startTime = getLastSwap(e);
        e = addEvent(e,'showStimulus',startTime);
        firstTrial = false;
    end

    i = i + 1;
    
    % compute next position
    s(i) = (getLastSwap(e) - startTime + 1 / refresh) * speed;
    pos = startPos + s(i) * [cos(angle); -sin(angle)];
    
    % flash?
    if s(i-1) < movingLoc && s(i) >= movingLoc
        flash = flashDuration;
    end    
end

% keep fixation spot and response targets after stimulus turns off
if ~abort

    % response targets
    Screen('DrawDots',win,[leftTarget rightTarget],targetRadius/2,targetColor,[],1);
    
    drawFixSpot(e);
    e = swap(e);
    
    % log stimulus offset event (when bar finished trajectory)
    e = addEvent(e,'endStimulus',getLastSwap(e));

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
    
    if ~abort
        e = clearScreen(e);
    end
else
    % log stimulus offset event (when bar finished trajectory)
    e = addEvent(e,'endStimulus',getLastSwap(e));
end

% save bar locations
e = setTrialParam(e,'barLocations',s(1:i-1));

% return values
retInt32 = int32(0);
returned = true;
