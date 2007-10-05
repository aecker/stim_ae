function e = showStimulus5(e)
% Show orientation gratings.  This method also shows a vertical grating at the top
% !! TODO: incorporate speed parameter !!

% some member variables..
win = get(e,'win');
con = get(e,'con');
curParams = get(e,'curParams');
curIndex = get(e,'curIndex');
params = get(e,'params');

% some shortcuts
if(isempty(e.textures))
    e = generateGaborTextures(e);
end
texture = squeeze(e.textures(curIndex.contrast,curIndex.spatialFreq,:));
direction = curParams.direction;
rect = Screen('Rect',win);

% control loop: we remove the stimulus after params.stimTime seconds or a
% tcp abort command, whichever comes first.
endTime = inf;
i = 0;
T = zeros(curParams.stimTime/10,1);

numFrames = length(texture);

try
    if(getPrev(getTrialData(e),'correctResponse'))
        e.correctSinceAdjust = e.correctSinceAdjust+1;
    else
        if(getPrev(getTrialData(e),'validTrial'))
            e.correctSinceAdjust = 0;
            e.currentDifficulty = 1 - (1 - e.currentDifficulty) * (1-curParams.staircaseStep);
        end
    end
    if(e.correctSinceAdjust >= curParams.stepCount)
        e.correctSinceAdjust = 0;
        e.currentDifficulty = 0 - (0 - e.currentDifficulty) * (1-curParams.staircaseStep);
    end
catch
    %probably first trial, no big deal
end

e = putTrialData(e,'difficulty',e.currentDifficulty);
e = putTrialData(e,'stimulus', 5);

while GetSecs < endTime

    t1 = GetSecs;

    % Check for abort signal
    fctName = pnet(con,'readline',2^16,'view','noblock');
    if ~isempty(fctName)
        % clear read buffer and abort
        pnet(con,'readline');
        e = feval(fctName,e);
        return;
    end

    % update grating
    wg = params.diskSize; %wg - width of grating.
    crect = CenterRect([0 0 wg wg],rect);
    Screen('DrawTexture',win,texture(1+mod(i*curParams.speed,numFrames)),[0 0  wg wg],crect,...
        mean(params.direction)+(direction-mean(params.direction))*e.currentDifficulty); 
	
	% Draw reference in bottom half of screen
%    crect = CenterRect([0 0 wg wg],[rect(1) rect(2) rect(3) (rect(2) + rect(4))/2]);
%    Screen('DrawTexture',win,texture(1),[0 0  wg wg],crect,mean(params.direction)); 
	
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

