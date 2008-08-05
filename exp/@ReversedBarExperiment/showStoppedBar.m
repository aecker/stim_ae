function e = showStoppedBar(e)
% show moving bar

% some member variables..
win = get(e,'win');

% determine starting position
len = getParam(e,'trajectoryLength');
dir = getParam(e,'direction');
angle = (getParam(e,'trajectoryAngle') + 180 * dir) / 180 * pi;
startPos = getParam(e,'trajectoryCenter') - len/2 * [cos(angle); -sin(angle)];
speed = getParam(e,'speed');
loc = getParam(e,'exceptionLocation') * len; % transform in pixels from relative numbers

% put start time
startTime = GetSecs;
firstTrial = true;
refresh = get(e,'refreshRate');
n = ceil(len / speed * refresh);
rf = ceil(loc / speed * refresh); % frame where reversal will occur

s = zeros(n,1);
pos = startPos;
i = 1;
abort = false;
for i=1:n % make trial n frames long and don't show stimulus after rf frame

    % check for abort signal
    [e,abort] = tcpMiniListener(e,{'netAbortTrial'});
    if abort
        break
    end

    % draw colored rectangle
    barSize = getParam(e,'barSize');
    rect = [pos - barSize/2; pos + barSize/2];
    if i<=rf 
        Screen('DrawTexture',win,e.tex,[],rect,-angle*180/pi); 
    else % there must be a better way of doing this
        Screen('DrawTexture',win,e.texInvisible,[],rect,-angle*180/pi); 
    end
    
    % buffer swap 
    e = swap(e);
    
    % compute timeout
    if firstTrial
        startTime = getLastSwap(e);
        e = addEvent(e,'showStimulus',startTime);
        firstTrial = false;
    end
    
    % compute next position
    s(i) = (getLastSwap(e) - startTime + 1 / refresh) * speed;
    pos = startPos + s(i) * [cos(angle); -sin(angle)];
end

%if i == 100, keyboard, end

% clear screen (abort clears the screen anyway in netAbortTrial, so skip it in
% this case)
if ~abort
    e = clearScreen(e);
end

% log stimulus offset event
e = addEvent(e,'endStimulus',getLastSwap(e));

% save bar locations
e = setTrialData(e,'barLocations',s(1:i-1));
