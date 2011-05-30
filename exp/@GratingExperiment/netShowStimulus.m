function [e,retInt32,retStruct,returned] = netShowStimulus(e,varargin)
% Show orientation gratings.

% some member variables..
win = get(e,'win');
rect = Screen('Rect',win);
refresh = get(e,'refreshRate');

% read parameters
curIdx = getParam(e,'condition');
location = getParam(e,'location');
spatialFreq = getParam(e,'spatialFreq');
orientation = getParam(e,'orientation');
phi0 = getParam(e,'initialPhase');      
speed = getParam(e,'speed');            % cyc/s
stimTime = getParam(e,'stimulusTime');
postStimTime = getParam(e,'postStimulusTime');

% some shortcuts
texture = e.textures(curIdx);
texSize = e.textureSize(curIdx);
alpha = e.alphaMask(curIdx);
centerX = mean(rect([1 3])) + location(1);
centerY = mean(rect([2 4])) + location(2);

% return function call
tcpReturnFunctionCall(e,int32(0),struct,'netShowStimulus');

% some values we need 
period = 1 / spatialFreq;
speed = speed * period / refresh;     % convert to px/frame

phi = phi0;
firstTrial = true;
running = true;
while running

    % check for abort signal
    [e,abort] = tcpMiniListener(e,{'netAbortTrial','netTrialOutcome'});
    if abort
        break
    end
    
    % update grating
    u = mod(phi,period) - period/2;
    xInc = -u * sin(orientation/180*pi);
    yInc = u * cos(orientation/180*pi);
    destRect = [-texSize -texSize texSize texSize] / 2 ...
        + [centerX centerY centerX centerY] + [xInc yInc xInc yInc];
    
    % draw texture, aperture, flip screen
    Screen('DrawTexture',win,texture,[],destRect,orientation); 
    Screen('DrawTexture',win,alpha); 
    drawFixSpot(e);
    e = swap(e);
    
    % compute startTime
    if firstTrial
        startTime = getLastSwap(e);
        e = addEvent(e,'showStimulus',startTime);
        firstTrial = false;
    end
    
    % compute timeOut
    running = (getLastSwap(e)-startTime)*1000 < stimTime;
   
    phi = phi + speed;
end

% keep fixation spot after stimulus turns off
if ~abort

    drawFixSpot(e);
    e = swap(e);

    % log stimulus offset event
    e = addEvent(e,'endStimulus',getLastSwap(e));

    while (GetSecs-startTime)*1000 < (stimTime + postStimTime);
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

% return values
retInt32 = int32(0);
retStruct = struct;
returned = true;

