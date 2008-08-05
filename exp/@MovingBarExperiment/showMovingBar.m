function [e,retInt32,retStruct,returned] = showMovingBar(e)
% show moving bar

% get Parameters
win =           get(e,'win');
len =           getParam(e,'trajectoryLength');
% prior =         getParam(e,'prior');
dir =           getParam(e,'direction');
trajAngle =     getParam(e,'trajectoryAngle');
trajCenter =    getParam(e,'trajectoryCenter');
speed =         getParam(e,'speed');
refresh =       get(e,'refreshRate');
barSize =       getParam(e,'barSize');
delayTime =     getParam(e,'delayTime');

% determine starting position
angle = (trajAngle + 180 * dir) / 180 * pi;
startPos = trajCenter - len/2 * [cos(angle); -sin(angle)];

% return function call
tcpReturnFunctionCall(e,int32(0),struct,'netShowStimulus');

% compute timing & length
startTime = GetSecs;
firstTrial = true;
n = ceil(len / speed * refresh);
stimTime = len/speed*1000;
s = zeros(1,n);
rect = zeros(4,n);
center = zeros(2,n);
center(:,1) = startPos;
i = 1;
abort = false;
while s(i) < len
    
    drawFixspot(e);

    % check for abort signal
    [e,abort] = tcpMiniListener(e,{'netAbortTrial','netTrialOutcome'});
    if abort
        break
    end

    % draw colored rectangle
    rect(:,i) = [center(:,i) - barSize/2; center(:,i) + barSize/2];
    Screen('DrawTexture',win,e.tex,[],rect(:,i),-angle*180/pi); 
    
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
    center(:,i) = startPos + s(i) * [cos(angle); -sin(angle)];
end


% keep fixation spot after stimulus turns off
if ~abort

    drawFixSpot(e);
    e = swap(e);

    % log stimulus offset event
    e = addEvent(e,'endStimulus',getLastSwap(e));

    while (GetSecs-startTime)*1000 < delayTime;
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
    % log stimulus offset event
    e = addEvent(e,'endStimulus',getLastSwap(e));
end

% save bar locations
e = setTrialParam(e,'barLocations',s(1:i-1));
e = setTrialParam(e,'barRects',rect);
e = setTrialParam(e,'barCenters',center(:,1:i-1));

% save timing information
e = setTrialParam(e,'stimulusTime',stimTime);
e = setTrialParam(e,'postStimulusTime',delayTime-stimTime);

% return values
retInt32 = int32(0);
retStruct = struct;
returned = true;
