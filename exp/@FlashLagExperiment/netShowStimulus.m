function [e,retInt32,retStruct,returned] = netShowStimulus(e,params)
% Show stimulus.
% AE 2007-10-17

% as this is a non-blocking function call from LabView, we have to return it
% manually
tcpReturnFunctionCall(e,int32(0),struct);

% some member variables..
win = get(e,'win');

% determine starting position
len = getParam(e,'trajectoryLength');
dir = (rand(1) > 0.5);
angle = (getParam(e,'trajectoryAngle') + 180 * dir) / 180 * pi;
startPos = getParam(e,'trajectoryCenter') - len/2 * [cos(angle); -sin(angle)];
speed = getParam(e,'speed');

% determine flash location
lagDir = 2 * (rand(1) > 0.5) - 1;
barSize = getParam(e,'barSize');
flashDuration = getParam(e,'flashDuration');
flashOffset = getParam(e,'flashOffset');
refresh = get(e,'refreshRate');
% we want the offset to be relative to the average location of the moving
% bar. Since the exact flash location is calculated when the flash starts
% we need to adjust the offset by the expected number of pixels the bar
% moves during the flash.
offsetX = (lagDir * flashOffset + flashDuration * speed / refresh / 2) ...
    * [cos(angle); -sin(angle)];
offsetY = (1.2 * barSize(2)) * [sin(mod(angle,pi)); cos(mod(angle,pi))];
offset = offsetX + offsetY;
flashMove = len / speed * flashDuration;
flashLoc = rand(1) * (len - abs(offset(1)) - flashMove) ...
           + (1 - lagDir > 0) * abs(offset(1));

% put start time
startTime = GetSecs;
firstTrial = true;
n = ceil(len / speed * refresh);
s = zeros(n,1);
pos = startPos;
i = 1;
abort = false;
flash = 0;
while s(i) < len

    % check for abort signal
    [e,abort] = tcpMiniListener(e,{'netAbortTrial'});
    if abort
        break
    end

    % draw colored rectangle
    barSize = getParam(e,'barSize');
    rect = [pos - barSize/2; pos + barSize/2];
    Screen('DrawTexture',win,e.tex,[],rect,-angle*180/pi); 
    
    % draw flashing bar
    if flash > 0
        if flash == flashDuration
            flashRect = [pos + offset - barSize/2; pos + offset + barSize/2];
        end
        Screen('DrawTexture',win,e.tex,[],flashRect,-angle*180/pi); 
        flash = flash - 1;
    end

    % draw photodiode spot; do buffer swap and keep timestamp
    e.photoDiodeTimer = swap(e.photoDiodeTimer,win);
    
    % compute timeout
    if firstTrial
        startTime = getSwapTimes(e.photoDiodeTimer);
        e = addEvent(e,'showStimulus',startTime);
        firstTrial = false;
    end

    i = i+1;
    
    % compute next position
    s(i) = (getLastSwap(e.photoDiodeTimer) - startTime + 1 / refresh) * speed;
    pos = startPos + s(i) * [cos(angle); -sin(angle)];
    
    % flash?
    if s(i-1) < flashLoc && s(i) >= flashLoc
        flash = flashDuration;
    end    
end

% clear screen (abort clears the screen anyway in netAbortTrial, so skip it in
% this case)
if ~abort
    e = clearScreen(e);
end

% read out buffer swap times and reset timer
swapTimes = getSwapTimes(e.photoDiodeTimer);
e = setTrialData(e,'swapTimes',swapTimes);
e.photoDiodeTimer = reset(e.photoDiodeTimer);

% save bar locations
e = setTrialData(e,'barLocations',s(1:i-1));





retInt32 = int32(0);
retStruct = struct;
returned = true;
