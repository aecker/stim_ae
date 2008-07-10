function [e,retInt32,retStruct,returned] = netShowStimulus(e,params)

% some member variables
win = get(e,'win');
rect = Screen('Rect',win);
refresh = get(e,'refreshRate');

% read parameters
curIdx = getParam(e,'condition');
location = getParam(e,'location');
stimTime = getParam(e,'stimTime');
postStimTime = getParam(e,'postStimTime');
fadeFactor = getParam(e,'fadeFactor');

n = getParam(e,'imageNumber');
imStats = cell2mat(getParam(e,'imageStats'));

fprintf('\n image id: %05.0f, image stats: %s',n,imStats);

% some shortcuts
texture = e.textures(curIdx);
texSize = fadeFactor*getParam(e,'diskSize');
alpha = e.alphaMask(curIdx);
centerX = mean(rect([1 3])) + location(1);
centerY = mean(rect([2 4])) + location(2);

% return function call
tcpReturnFunctionCall(e,int32(0),struct,'netShowStimulus');

firstTrial = true;
running = true;
while running

    % check for abort signal
    [e,abort] = tcpMiniListener(e,{'netAbortTrial','netTrialOutcome'});
    if abort
        break
    end
    
    destRect = [-texSize -texSize texSize texSize] / 2 ...
                    + [centerX centerY centerX centerY];
    
    % draw texture, aperture, flip screen
    Screen('DrawTexture',win,texture,[],destRect,0); 
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

% return values
retInt32 = int32(0);
retStruct = struct;
returned = true;

