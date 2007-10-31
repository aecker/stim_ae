function e = showStimulus(e)
% Show orientation gratings.
% !! TODO: incorporate speed parameter !!

% some member variables..
win = get(e,'win');
con = get(e,'con');
curParams = get(e,'curParams');
curIndex = get(e,'curIndex');

% some shortcuts
texture = e.textures(curIndex.contrast,curIndex.spatialFreq);
texSize = e.textureSize(curIndex.contrast,curIndex.spatialFreq);
alpha = e.alphaMask(curIndex.location,curIndex.bgColor,curIndex.diskSize);
direction = curParams.direction;
rect = Screen('Rect',win);
centerX = mean(rect([1 3])) + curParams.location(1);
centerY = mean(rect([2 4])) + curParams.location(2);

% some values we need 
period = 2*pi / curParams.spatialFreq;

% control loop: we remove the stimulus after params.stimTime seconds or a
% tcp abort command, whichever comes first.
endTime = inf;
i = 0;
T = zeros(curParams.stimTime/10,1);
while GetSecs < endTime

    t1 = GetSecs;

    % Check for abort signal
    [e,abort] = checkForAbort(e);
    if abort
        return
    end
    
    % update grating
    u = mod(i,period) - period/2;
    xInc = -u * sin(direction/180*pi);
    yInc = u * cos(direction/180*pi);
    destRect = [-texSize -texSize texSize texSize] / 2 ...
        + [centerX centerY centerX centerY] + [xInc yInc xInc yInc];
    Screen('DrawTexture',win,texture,[],destRect,direction); 
    
    % draw aperture
    Screen('DrawTexture',win,alpha); 
    
    % draw fixspot
    drawFixSpot(e);
    
%     fprintf('this iteration: %6.2f\n',(GetSecs-t1)*1000)
    T(i+1) = (GetSecs - t1) * 1000;

    % flip buffers
    vblTime = Screen('Flip',win);
    
    % first iteration. store start time and compute end time
    if i == 0
        e = addEvent(e,'showStimulus',vblTime);
        endTime = vblTime + curParams.stimTime/1000;
    end
    i = i+1;
end

% send 'completed' to state system
pnet(con,'write',uint8(1));

% clear screen
e = clearScreen(e);

