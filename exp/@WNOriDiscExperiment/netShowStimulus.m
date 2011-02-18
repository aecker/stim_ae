function [e,retInt32,retStruct,returned] = netShowStimulus(e,varargin)
% Show white noise orientation with added signal (i.e. one orientation is
% more likeli to be shown than all the others).
%
% AE 2010-10-14

win = get(e,'win');
rect = Screen('Rect',win);
refresh = get(e,'refreshRate');

% read parameters
condNdx = getParam(e,'condition');
stimTime = getParam(e,'stimulusTime');
postStimTime = getParam(e,'postStimulusTime');
stimFrames = getParam(e,'stimFrames');
stimLoc = getParam(e,'stimulusLocation');
spatialFreq = getParam(e,'spatialFreq');
pxPerDeg = getPxPerDeg(getConverter(e));
spatialFreq = spatialFreq / pxPerDeg(1);
period = 1 / spatialFreq;

% compute number of frames
flipInterval = stimFrames * 1000 / refresh; % frame duration in msec ~= 10 msec
nFrames = ceil(stimTime / flipInterval);

% obtain orientations to show
random = get(e,'randomization');
[orientations,random,acutalFraction] = getOrientations(random,nFrames);
e = set(e,'randomization',random);
e = setTrialParam(e,'acutalFraction',acutalFraction);

% conditions (for phase)
cond = getConditions(random);
phase = cond(condNdx).phase;

% return function call
tcpReturnFunctionCall(e,int32(0),struct,'netShowStimulus');

for i = 1:nFrames*stimFrames

    % check for abort signal
    [e,abort] = tcpMiniListener(e,{'netAbortTrial','netTrialOutcome'});
    if abort
        fprintf('stimulus was aborted\n')
        break
    end
    
    % grating parameters
    orientation = orientations(ceil(i / stimFrames));
    
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
    
    % fixation spot
    drawFixspot(e);
    e = swap(e);
    
    % compute startTime
    if i == 1
        startTime = getLastSwap(e);
        e = addEvent(e,'showStimulus',startTime);
    end
end

% keep fixation spot after stimulus turns off
if ~abort

    drawFixspot(e);
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

% store shown stimuli
e = setTrialParam(e,'noiseOrientations',orientations(1:ceil(i / stimFrames)));

% return values
retInt32 = int32(0);
retStruct = struct;
returned = true;
