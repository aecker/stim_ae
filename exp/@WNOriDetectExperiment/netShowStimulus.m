function [e, retInt32, retStruct, returned] = netShowStimulus(e, varargin)
% Show white noise orientation until at a random time signal frames are
% injected for some period of time.
%
% AE/GD 2012-11-13

win = get(e, 'win');
refresh = get(e, 'refreshRate');

% read parameters
stimLoc = getParam(e, 'stimulusLocation');
monitorCenter = getParam(e, 'monitorCenter');
spatialFreq = getParam(e, 'spatialFreq');
pxPerDeg = getPxPerDeg(getConverter(e));
spatialFreq = spatialFreq / pxPerDeg(1);
period = 1 / spatialFreq;
signal = getParam(e, 'signal');
phase = getParam(e, 'phase');

% catch trial
catchTrial = isnan(signal);
if catchTrial
    nFramesPre = getParam(e, 'nFramesPreMax');
    nFramesCoh = 0;
    nFramesPost = 0;
    cohOrientations = [];
    postOrientations = [];
else
    % determine number of frames before change (constant hazard function)
    nFramesPreMin = getParam(e, 'nFramesPreMin');
    nFramesPreMean = getParam(e, 'nFramesPreMean');
    nFramesPreMax = getParam(e, 'nFramesPreMax');
    nFramesPre = min(nFramesPreMax, round(exprnd(nFramesPreMean - nFramesPreMin)) + nFramesPreMin);
    nFramesCoh = getParam(e, 'nFramesCoh');
    nFramesPost = ceil(getParam(e, 'responseTime') / 1000 * refresh);
    
    % generate "coherent" portion of trial
    coherence = getParam(e, 'coherence');
    cohOrientations = getCoherentOrientations(e, nFramesCoh, signal, coherence);

    % generate post-coherent (completely random) sequence of orientations
    postOrientations = getRandomOrientations(e, nFramesPost);
end

% generate pseudorandom orientations (fixed seed) before the change
seed = getParam(e, 'seed');
preOrientations = getRandomOrientations(e, nFramesPre, seed);

orientations = [preOrientations, cohOrientations, postOrientations];

% return function call
params.delayTime = nFramesPre / refresh * 1000 + getParam(e, 'waitTime');
params.catchTrial = catchTrial;
tcpReturnFunctionCall(e, int32(0), params, 'netShowStimulus');

% Run stimulus loop
nFramesTotal = nFramesPre + nFramesCoh + nFramesPost;
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
e = setTrialParam(e, 'delayTime', params.delayTime);
e = setTrialParam(e, 'catchTrial', catchTrial);

% return values
retInt32 = int32(0);
retStruct = struct;
returned = true;
