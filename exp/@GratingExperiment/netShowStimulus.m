function [e,retInt32,retStruct,returned] = netShowStimulus(e,params)
% Show orientation gratings.

% some member variables..
win = get(e,'win');
con = get(e,'con');
rect = Screen('Rect',win);


% get current parameter
r = get(e,'randomization');
conditions = getConditions(r);

% read parameters
curIdx = getParam(e,'condition');
location = getParam(e,'location');
spatialFreq = getParam(e,'spatialFreq');
direction = getParam(e,'direction');



% some shortcuts
texture = e.textures(curIdx);
texSize = e.textureSize(curIdx);
alpha = e.alphaMask(curIdx);
centerX = mean(rect([1 3])) + location(1);
centerY = mean(rect([2 4])) + location(2);

% return function call
tcpReturnFunctionCall(e,int32(0),struct,'netShowStimulus');

% some values we need 
period = 2*pi / spatialFreq;

i=1;
firstTrial = true;
running = true;
while running

    drawFixspot(e);

    % check for abort signal
    [e,abort] = tcpMiniListener(e,{'netAbortTrial','netTrialOutcome'});
    if abort
        break
    end
    
    % update grating
    u = mod(i,period) - period/2;
    xInc = -u * sin(direction/180*pi);
    yInc = u * cos(direction/180*pi);
    destRect = [-texSize -texSize texSize texSize] / 2 ...
        + [centerX centerY centerX centerY] + [xInc yInc xInc yInc];
    
    % draw texture, aperture, flip screen
    Screen('DrawTexture',win,texture,[],destRect,direction); 
    Screen('DrawTexture',win,alpha); 
    e = swap(e);
    
    % compute startTime
    if firstTrial
        startTime = getLastSwap(e);
        e = addEvent(e,'showStimulus',startTime);
        firstTrial = false;
    end
    
    % compute timeOut
    running = (getLastSwap(e)-startTime) < delayTime;
    
    i = i+1;
end


if ~abort
    e = clearScreen(e);
end

% return values
retInt32 = int32(0);
retStruct = struct;
returned = true;

