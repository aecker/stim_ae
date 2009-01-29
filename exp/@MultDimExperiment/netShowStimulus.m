function [e,retInt32,retStruct,returned] = netShowStimulus(e,params)
% Show multidimensional oriented gratings.
%
%   TODO: color
%
% AE 2009-01-29

% some member variables
win = get(e,'win');
rect = Screen('Rect',win);
refresh = get(e,'refreshRate');

% read parameters
stimTime = getParam(e,'stimulusTime');
stimFrames = getParam(e,'stimFrames');
location = getParam(e,'location');
postStimTime = getParam(e,'postStimulusTime');

% compute number of frames
flipInterval = 1000 / refresh; % frame duration in msec ~= 10 msec
m = ceil(stimTime / flipInterval);
nFrames = ceil(m / stimFrames);

% obtain conditions to show
random = get(e,'randomization');
[conds,random] = getParams(random,nFrames);
e = set(e,'randomization',random);

% some shortcuts
centerX = mean(rect([1 3])) + location(1);
centerY = mean(rect([2 4])) + location(2);

% return function call
tcpReturnFunctionCall(e,int32(0),struct,'netShowStimulus');

frames = 0;
k = 0;
for i = 1:nFrames*stimFrames

    % check for abort signal
    [e,abort] = tcpMiniListener(e,{'netAbortTrial','netTrialOutcome'});
    if abort
        fprintf('stimulus was aborted.....................................\n')
        break
    end
    
    % new stimulus after n frames
    if frames == 0
        k = k+1;
        frames = stimFrames;
    end

    % draw texture, aperture, flip screen
    ts = e.textureSize(conds(k));
    destRect = [centerX centerY centerX centerY] + [-ts -ts ts ts] / 2;
    Screen('DrawTexture',win,e.textures(conds(k)),[],destRect); 
    Screen('DrawTexture',win,e.alphaMask); 
    drawFixspot(e);
    e = swap(e);

    % compute startTime
    if i == 1
        startTime = getLastSwap(e);
        e = addEvent(e,'showStimulus',startTime);
    end
    
    frames = frames - 1;
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

% store shown stimuli
e = setTrialParam(e,'conditions',conds(1:k));

% return values
retInt32 = int32(0);
retStruct = struct;
returned = true;

