function e = showBarReversal(e)
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
revS = [];
for i=1:n

    % check for abort signal
    [e,abort] = tcpMiniListener(e,{'netAbortTrial'});
    if abort
        break
    end

    % draw colored rectangle
    barSize = getParam(e,'barSize');
    rect = [pos - barSize/2; pos + barSize/2];
    Screen('DrawTexture',win,e.tex,[],rect,-angle*180/pi); 
    
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
    if i == rf
        revS = s(i);  % remember position
    elseif i >= rf    
        s(i) = 2*revS - s(i);   % go back from position 
    end
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
