function [e,retInt32,retStruct,returned] = netShowStimulus(e,params)
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
stimTime = getParam(e,'stimTime');
postStimTime = getParam(e,'postStimTime');

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
% speed = speed * refresh / 1000 * period;     % convert to px/frame
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
    drawFixspot(e);
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

    % Does the monkey have to fixate?
    if getParam(e,'eyeControl')
        drawFixSpot(e);
        e = swap(e);
        
        while (GetSecs-startTime)*1000 < stimTime+postStimTime;
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

% log stimulus offset event
e = addEvent(e,'endStimulus',getLastSwap(e));

% return values
retInt32 = int32(0);
retStruct = struct;
returned = true;

