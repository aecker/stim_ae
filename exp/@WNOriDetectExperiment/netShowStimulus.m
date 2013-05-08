function [e, retInt32, retStruct, returned] = netShowStimulus(e, varargin)
% Show white noise orientation until at a random time signal frames are
% injected for some period of time.
%
% AE/GD 2012-11-13

win = get(e, 'win');
refresh = get(e, 'refreshRate');
monitorCenter = getParam(e, 'monitorCenter');
fixSpotSize = getParam(e, 'fixSpotSize');
fixSpotLocation = monitorCenter + getParam(e, 'fixSpotLocation');
biases = getParam(e, 'biases');
cue = getParam(e, 'cue');

stimLoc = getParam(e, 'stimulusLocation');
phase = getParam(e, 'phase');
waitTime = getParam(e, 'waitTime');
spatialFreq = getParam(e, 'spatialFreq');
pxPerDeg = getPxPerDeg(getConverter(e));
spatialFreq = spatialFreq / pxPerDeg(1);
period = 1 / spatialFreq;

% We allow the following parameter be overridden for training. They are set
% in netStartTrial to either what LabView passes or what the config file
% indicates
nFramesPreMin = getParam(e, 'nFramesPreMinTrain');
nFramesPreMean = getParam(e, 'nFramesPreMeanTrain');
nFramesPreMax = getParam(e, 'nFramesPreMaxTrain');
nFramesCoh = getParam(e, 'nFramesCohTrain');
responseInterval = getParam(e, 'responseIntervalTrain');
signal = getParam(e, 'signalTrain');
coherence = getParam(e, 'coherenceTrain');
coherence = min(coherence, nFramesCoh);
catchTrial = getParam(e, 'isCatchTrialTrain');

% fixation spot color
if cue
    r = get(e, 'randomization');
    bias = biases(:, getBias(r));
    fixSpotColor = 255 * [bias / max(bias); 0];
else
    fixSpotColor = getParam(e, 'fixSpotColor');
end

% catch trial
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
params.delayTime = nFramesPre / refresh * 1000 + waitTime;
params.catchTrial = catchTrial;
params.responseTime = (nFramesCoh + nFramesPost) / refresh * 1000 - waitTime;
params.stimulusLocation = stimLoc;
params.nFramesPreFraction = (nFramesPre - nFramesPreMin) / max(1, nFramesPreMax - nFramesPreMin);
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
    if cue
        Screen('DrawDots', win, fixSpotLocation, fixSpotSize + 4, zeros(1, 3), [], 1);
    end
    Screen('DrawDots', win, fixSpotLocation, fixSpotSize, fixSpotColor, [], 1);
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
e = setTrialParam(e, 'delayTime', params.delayTime);
e = setTrialParam(e, 'responseTime', params.responseTime);
e = setTrialParam(e, 'catchTrial', catchTrial);

% return values
retInt32 = int32(0);
retStruct = struct;
returned = true;
