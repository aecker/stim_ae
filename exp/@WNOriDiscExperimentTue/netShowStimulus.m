function [e,retInt32,retStruct,returned] = netShowStimulus(e,eyeTracker)
% Show white noise orientation with added signal (i.e. one orientation is
% more likely to be shown than all the others).
%
% AE 2011-09-14

win = get(e,'win');
rect = Screen('Rect',win);
refresh = get(e,'refreshRate');

% read parameters
condNdx = getParam(e,'condition');
stimTime = getParam(e,'stimulusTime');
stimFrames = getParam(e,'stimFrames');
stimLoc = getParam(e,'stimulusLocation');
spatialFreq = getParam(e,'spatialFreq');
bgColor = getParam(e,'bgColor');
pxPerDeg = getPxPerDeg(getConverter(e));
spatialFreq = spatialFreq / pxPerDeg(1);
period = 1 / spatialFreq;

responseButtons = getParam(e,'responseButtons');
buttonsOn = zeros(1, 5);
buttonsOn(responseButtons) = 1;

% setup response box to start with stimulus
ResponsePixx('StartAtFlip', [], 1, buttonsOn);

% compute number of frames
flipInterval = stimFrames * 1000 / refresh; % frame duration in msec ~= 10 msec
nFrames = ceil(stimTime / flipInterval);

% obtain orientations to show
random = get(e,'randomization');
[orientations,random,actualFraction] = getOrientations(random,nFrames);
e = set(e,'randomization',random);
e = setTrialParam(e,'actualFraction',actualFraction);

% conditions (for phase)
cond = getConditions(random);
phase = cond(condNdx).phase;

buttonPressed = 0;
frame = 1;
while ~buttonPressed
    
    Screen('FillRect',win,bgColor);
    
    if frame < nFrames * stimFrames
        
        % grating parameters
        orientation = orientations(ceil(frame / stimFrames));
        
        % move grating
        u = mod(phase,360) / 360 * period;
        xo = -u * sin(orientation/180*pi);
        yo = u * cos(orientation/180*pi);
        ts = e.textureSize / 2;
        cx = mean(rect([1 3])) + stimLoc(1);
        cy = mean(rect([2 4])) + stimLoc(2);
        destRect = [cx cy cx cy] + ts * [-1 -1 1 1] + [xo yo xo yo];
        
        % draw grating
        Screen('DrawTexture',win,e.texture,[],destRect,orientation+90);
        
        % draw circular aperture
        Screen('DrawTexture',win,e.alphaMask);

    elseif frame == nFrames * stimFrames
    
        % log stimulus offset event
        e = addEvent(e,'endStimulus',getLastSwap(e));
    end
    
    % fixation spot
    drawFixSpot(e);
    e = swap(e);

    % compute startTime
    if frame == 1
        startTime = getLastSwap(e);
        e = addEvent(e,'showStimulus',startTime);
    end
    
    % check if fixating
    fixating = monitorFixation(eyeTracker);
    if ~fixating
        e = setTrialParam(e,'response',NaN);
        e = setTrialParam(e,'correctResponse',false);
        e = setTrialParam(e,'validTrial',false);
        break
    end
    
    % check for response
    buttonPressed = getButtonPress(responseButtons);
    if buttonPressed ~= 0
        ResponsePixx('StopNow',[],[0 0 0 0 0]);
        e = clearScreen(e);
        
        if buttonPressed > 0
            resp = find(responseButtons == buttonPressed,1);
            e = setTrialParam(e,'response',resp);
            e = setTrialParam(e,'validTrial',true);
            correct = find(getParam(e, 'signal') == getParam(e, 'signals'));
            e = setTrialParam(e,'correctResponse',resp == correct);
        else
            e = setTrialParam(e,'response',-1);
            e = setTrialParam(e,'correctResponse',NaN);
            e = setTrialParam(e,'validTrial',false);
        end
    end
    
    frame = frame + 1;
end

if fixating
    endTrial(eyeTracker);
end

% store shown stimuli
e = setTrialParam(e,'noiseOrientations',orientations(1:min(end, ceil(frame / stimFrames))));

% return values
retInt32 = int32(0);
retStruct = struct;
returned = true;
