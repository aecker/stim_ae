function [e, retInt32, retStruct, returned] = netShowStimulus(e, varargin)
% Show white noise orientation until at a random time signal frames are
% injected for some period of time.
%
% AE/GD 2012-11-13

win = get(e, 'win');
refresh = get(e, 'refreshRate');
monitorCenter = getParam(e, 'monitorCenter');

% we allow the following parameter be overridden for training. in that case
% they get passed from LabView into netShowStimulus as the second input
stimLoc = getParamOrOverride(e, 'stimulusLocation', varargin{:});
signal = getParamOrOverride(e, 'signal', varargin{:});
phase = getParamOrOverride(e, 'phase', varargin{:});
nFramesPreMin = getParamOrOverride(e, 'nFramesPreMin', varargin{:});
nFramesPreMean = getParamOrOverride(e, 'nFramesPreMean', varargin{:});
nFramesPreMax = getParamOrOverride(e, 'nFramesPreMax', varargin{:});
nFramesCoh = getParamOrOverride(e, 'nFramesCoh', varargin{:});
coherence = getParamOrOverride(e, 'coherence', varargin{:});
waitTime = getParamOrOverride(e, 'waitTime', varargin{:});
responseInterval = getParamOrOverride(e, 'responseInterval', varargin{:});
spatialFreq = getParamOrOverride(e, 'spatialFreq', varargin{:});
pxPerDeg = getPxPerDeg(getConverter(e));
spatialFreq = spatialFreq / pxPerDeg(1);
period = 1 / spatialFreq;

% store overrides
e = setParams(e, varargin{:});

% catch trial
catchTrial = isnan(signal);
if catchTrial
    nFramesPre = nFramesPreMax;
    nFramesCoh = 0;
    nFramesPost = 0;
    cohOrientations = [];
    postOrientations = [];
    fprintf('catch trial\n')
else
    % determine number of frames before change (constant hazard function)
    nFramesPre = min(nFramesPreMax, round(exprnd(nFramesPreMean - nFramesPreMin)) + nFramesPreMin);
    nFramesPost = ceil(responseInterval / 1000 * refresh);
    
    % generate "coherent" portion of trial
    if isinf(signal)
        orientations = getParam(e, 'orientations');
        actualSignal = orientations(ceil(rand(1) * numel(orientations)));
    else
        actualSignal = signal;
    end
    e = setTrialParam(e, 'actualSignal', actualSignal);
    cohOrientations = getCoherentOrientations(e, nFramesCoh, actualSignal, coherence);

    % generate post-coherent (completely random) sequence of orientations
    postOrientations = getRandomOrientations(e, nFramesPost);

    fprintf('signal: %3d | coherence: %2d | frames pre: %d | total frames: %d\n', actualSignal, coherence, nFramesPre, nFramesPre + nFramesCoh + nFramesPost)
end

% generate pseudorandom orientations (fixed seed) before the change
seed = getParam(e, 'seed');
preOrientations = getRandomOrientations(e, nFramesPre, seed);

orientations = [preOrientations, cohOrientations, postOrientations];

% Run stimulus loop
nFramesTotal = nFramesPre + nFramesCoh + nFramesPost;

% return function call
params.responseStart = nFramesPre / refresh * 1000 + waitTime;
params.catchTrial = catchTrial;
params.abortTime = nFramesTotal / refresh * 1000; % get in milliseconds
params.stimulusLocation = stimLoc;
tcpReturnFunctionCall(e, int32(0), params, 'netShowStimulus');

for i = 1 : nFramesTotal

    % check for abort signal
    [e, abort] = tcpMiniListener(e, {'netAbortTrial', 'netTrialOutcome'});
    if abort
        fprintf('stimulus was aborted\n')
        break
    end

    % move grating
    u = mod(phase, 360) / 360 * period;
    xo = -u * sin(orientations(i) / 180 * pi);
    yo = u * cos(orientations(i) / 180 * pi);
    ts = e.textureSize / 2;
    cx = monitorCenter(1) + stimLoc(1);
    cy = monitorCenter(2) + stimLoc(2);
    destRect = [cx cy cx cy] + ts * [-1 -1 1 1] + [xo yo xo yo];

    % draw grating
    Screen('DrawTexture', win, e.texture, [], destRect, orientations(i) + 90);

    % draw circular aperture
    Screen('DrawTexture', win, e.alphaMask);

    % fixation spot
    drawFixSpot(e);
    e = swap(e);

    % compute startTime
    if i == 1
        startTime = getLastSwap(e);
        e = addEvent(e, 'showStimulus', startTime);
    end
    
    % log start and end of coherent phase
    if i == nFramesPre + 1
        e = addEvent(e, 'startCoherent', getLastSwap(e));
    elseif i == nFramesPre + nFramesCoh + 1;
        e = addEvent(e, 'endCoherent', getLastSwap(e));
    end
end

% abort and trialOutcome clear the screen. Otherwise we need to do it
if ~abort
    e = clearScreen(e);
end

% log stimulus offset event
e = addEvent(e, 'endStimulus', getLastSwap(e));

% store shown stimuli
oriPre = orientations(1 : min(i, nFramesPre));
oriCoh = orientations(min(i, nFramesPre) + 1 : min(i, nFramesPre + nFramesCoh));
oriPost = orientations(min(i, nFramesPre + nFramesCoh) + 1 : min(i, end));
e = setTrialParam(e, 'orientationsPre', oriPre);
e = setTrialParam(e, 'orientationsCoh', oriCoh);
e = setTrialParam(e, 'orientationsPost', oriPost);
e = setTrialParam(e, 'orientationsAll', orientations(1 : i));
e = setTrialParam(e, 'nFramesPre', numel(oriPre));
e = setTrialParam(e, 'nFramesPost', numel(oriPost));
e = setTrialParam(e, 'responseStart', params.responseStart);
e = setTrialParam(e, 'catchTrial', catchTrial);

% return values
retInt32 = int32(0);
retStruct = struct;
returned = true;


function val = getParamOrOverride(e, name, params)
% Get experimental parameter allowing by-trial overrides from LabView
% Overrides have the string 'Train' appended (i.e. 'foo' -> 'fooTrain').

nameTrain = [name 'Train'];
if nargin > 2 && isfield(params, nameTrain)
    val = params.(nameTrain);
else
    val = getParam(e, name);
end
