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

addCoh = getParam(e, 'addCoh');
orthSig = getParam(e, 'orthogonalSignal');
stimLoc = getParam(e, 'stimulusLocation');
nLocations = size(stimLoc, 2);
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
location = getParam(e, 'locationTrain');
coherence = getParam(e, 'coherenceTrain');
coherence = min(coherence, nFramesCoh);

% fixation spot color
if cue
    r = get(e, 'randomization');
    bias = biases(:, getBias(r));
    fixSpotColor = 255 * [bias / max(bias); 0];
else
    fixSpotColor = getParam(e, 'fixSpotColor');
end

% determine number of frames before change 
%   - constant hazard function after nFramesPreMin
%   - catch trial if drawn change time > nFramesPreMax
nFramesPre = exprnd(nFramesPreMean - nFramesPreMin) + nFramesPreMin;
catchTrial = nFramesPre > nFramesPreMax;

% catch trial
if catchTrial
    nFramesPre = nFramesPreMax;
    nFramesCoh = 0;
    nFramesPost = 0;
    nFramesTotal = nFramesPre;
    cohOrientations = [];
    postOrientations = [];
    actualLocation = -1;
    fprintf('catch trial\n')
else
    nFramesPre = round(nFramesPre);
    nFramesPost = ceil(responseInterval / 1000 * refresh);
    nFramesTotal = nFramesPre + nFramesCoh + nFramesPost;

    % draw random signal if necessary
    if isinf(signal)
        orientations = getParam(e, 'orientations');
        actualSignal = orientations(ceil(rand(1) * numel(orientations))); %%%% RAND %%%%
    else
        actualSignal = signal;
    end
    
    % draw random location if necessary
    if isinf(location)
        stimulusLocation = getParam(e, 'stimulusLocation');
        actualLocation = ceil(rand(1) * size(stimulusLocation, 2)); %%%% RAND %%%%
    else
        actualLocation = location;
    end
    e = setTrialParam(e, 'actualLocation', actualLocation);
    
    % use orthogonal signal for 2nd location
    if orthSig && actualLocation == 2 && actualSignal >= 90
        actualSignal = actualSignal - 90;
    elseif orthSig && actualLocation == 2
        actualSignal = actualSignal + 90;
    end
    e = setTrialParam(e, 'actualSignal', actualSignal);

    % generate "coherent" portion of trial
    % cohOrientations = getCoherentOrientations(e, nFramesCoh, actualSignal, coherence);

    % generate "coherent" portion of trial TO INCREASE COH IN 50-50
    % BLOCK
    if any(bias == 2)
        coherence = coherence + addCoh;
        cohOrientations = getCoherentOrientations(e, nFramesCoh, actualSignal, coherence);
    else 
        cohOrientations = getCoherentOrientations(e, nFramesCoh, actualSignal, coherence);
    end
    
    % generate post-coherent (completely random) sequence of orientations
    postOrientations = getRandomOrientations(e, nFramesPost);

    fprintf('signal: %3d | location: %d | coherence: %2d | frames pre: %d | total frames: %d\n', ...
        actualSignal, actualLocation, coherence, nFramesPre, nFramesTotal)
end

% fix random number generator seed
seed = getParam(e, 'seed');
state = rand('state');                                      %#ok<*RAND>
rand('state', seed)

% generate seeds for each target location
targetSeeds = ceil(rand(1, nLocations) * 1e6);

% generate pseudorandom orientations (fixed seed)
for i = 1 : nLocations
    rand('state', targetSeeds(i))
    orientations(i, :) = getRandomOrientations(e, nFramesTotal);
end



% insert coherent period and gratings post at target location
if ~catchTrial
    orientations(actualLocation, nFramesPre + 1 : end) = [cohOrientations, postOrientations];
end

% reset random number generator
rand('state', state);

% return function call
params.delayTime = nFramesPre / refresh * 1000 + waitTime;
params.catchTrial = catchTrial;
params.responseTime = (nFramesCoh + nFramesPost) / refresh * 1000 - waitTime;
params.stimulusLocation = stimLoc;
params.location = actualLocation;
params.nFramesPreFraction = (nFramesPre - nFramesPreMin) / max(1, nFramesPreMax - nFramesPreMin);
tcpReturnFunctionCall(e, int32(0), params, 'netShowStimulus');

for i = 1 : nFramesTotal

    % check for abort or response signal
    [e, abort] = tcpMiniListener(e, {'netAbortTrial', 'netTrialOutcome'});
    if abort
        break
    end

    % draw gratings
    for j = 1 : size(stimLoc, 2)
        u = mod(phase, 360) / 360 * period;
        xo = -u * sin(orientations(i) / 180 * pi);
        yo = u * cos(orientations(i) / 180 * pi);
        ts = e.textureSize / 2;
        cx = monitorCenter(1) + stimLoc(1, j);
        cy = monitorCenter(2) + stimLoc(2, j);
        destRect = [cx cy cx cy] + ts * [-1 -1 1 1] + [xo yo xo yo];
        Screen('DrawTexture', win, e.texture, [], destRect, orientations(j, i) + 90);
    end
    
    % overlay alpha mask
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
oriPre = orientations(:, 1 : min(i, nFramesPre));
oriCoh = orientations(:, min(i, nFramesPre) + 1 : min(i, nFramesPre + nFramesCoh));
oriPost = orientations(:, min(i, nFramesPre + nFramesCoh) + 1 : min(i, end));
e = setTrialParam(e, 'orientationsPre', oriPre);
e = setTrialParam(e, 'orientationsCoh', oriCoh);
e = setTrialParam(e, 'orientationsPost', oriPost);
e = setTrialParam(e, 'orientationsAll', orientations(:, 1 : i));
e = setTrialParam(e, 'nFramesPre', numel(oriPre(1,:)));
e = setTrialParam(e, 'nFramesPost', numel(oriPost));
e = setTrialParam(e, 'delayTime', params.delayTime);
e = setTrialParam(e, 'responseTime', params.responseTime);
e = setTrialParam(e, 'catchTrial', catchTrial);
if cue % if clause to make compatible when no cue
    e = setTrialParam(e, 'bias', bias); % new
    e = setTrialParam(e, 'fixSpotColor', fixSpotColor);
end

% return values
retInt32 = int32(0);
retStruct = struct;
returned = true;
