function e = showFlickeringBar(e)
% show flickering bars for receptive field mapping.

% some member variables..
win = get(e,'win');

% determine starting position
len = getParam(e,'trajectoryLength');
dir = (rand(1) > getParam(e,'prior'));
angle = (getParam(e,'trajectoryAngle') + 180 * dir) / 180 * pi;
startPos = getParam(e,'trajectoryCenter') - len/2 * [cos(angle); -sin(angle)];

% put start time
startTime = GetSecs;
mappingTime = getParam(e,'mapTime');
refresh = get(e,'refreshRate');
fpLoc = getParam(e,'mapFramesPerLoc');
n = ceil(mappingTime / (1000 / refresh * fpLoc));
s = zeros(n,1);
i = 1;
abort = false;
while (GetSecs - startTime) * 1000 < mappingTime - (1000 / refresh)
    
    % check for abort signal
    [e,abort] = tcpMiniListener(e,{'netAbortTrial'});
    if abort
        break
    end

    % change position only every couple frames
    if mod(i-1,fpLoc)==0
        s(i) = rand(1) * len;
    else
        s(i) = s(i-1);
    end
    pos = startPos + s(i) * [cos(angle); -sin(angle)];
    
    % draw colored rectangle
    barSize = getParam(e,'barSize');
    rect = [pos - barSize/2; pos + barSize/2];
    Screen('DrawTexture',win,e.tex,[],rect,-angle*180/pi); 
    
    % buffer swap
    e = swap(e);
    
    % compute timeout
    if i == 1;
        startTime = getLastSwap(e);
        e = addEvent(e,'showStimulus',startTime);
    end

    i = i+1;

end

% clear screen (abort clears the screen anyway in netAbortTrial, so skip it in
% this case)
if ~abort
    e = clearScreen(e);
end

% save bar locations
e = setTrialData(e,'barLocations',s);
