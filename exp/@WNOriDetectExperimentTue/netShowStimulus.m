function [e, eyeTracker] = netShowStimulus(e, eyeTracker)
% Show white noise orientation with added signal (i.e. one orientation is
% more likely to be shown than all the others).
%
% AE 2011-09-14

win = get(e, 'win');
refresh = get(e, 'refreshRate');

% stimulus parameters
stimLoc = getParam(e, 'stimulusLocation');
signal = getParam(e, 'signal');
phase = getParam(e, 'phase');
nFramesPreMin = getParam(e, 'nFramesPreMin');
nFramesPreMean = getParam(e, 'nFramesPreMean');
nFramesPreMax = getParam(e, 'nFramesPreMax');
nFramesCoh = getParam(e, 'nFramesCoh');
coherence = getParam(e, 'coherence');
waitTime = getParam(e, 'waitTime');
responseTime = getParam(e, 'responseTime');
spatialFreq = getParam(e, 'spatialFreq');
pxPerDeg = getPxPerDeg(getConverter(e));
spatialFreq = spatialFreq / pxPerDeg(1);
period = 1 / spatialFreq;

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
    nFramesPost = ceil(responseTime / 1000 * refresh);
    
    % generate "coherent" portion of trial
    cohOrientations = getCoherentOrientations(e, nFramesCoh, signal, coherence);

    % generate post-coherent (completely random) sequence of orientations
    postOrientations = getRandomOrientations(e, nFramesPost);

    fprintf('signal: %3d | coherence: %2d | frames pre: %d\n', signal, coherence, nFramesPre)
end

% generate pseudorandom orientations (fixed seed) before the change
seed = getParam(e, 'seed');
preOrientations = getRandomOrientations(e, nFramesPre, seed);

orientations = [preOrientations, cohOrientations, postOrientations];
nFramesTotal = nFramesPre + nFramesCoh + nFramesPost;
delayTime = nFramesPre / refresh * 1000 + waitTime;

% setup response box to start with stimulus
responseButtons = getParam(e, 'responseButtons');
buttonsOn = zeros(1, 5);
buttonsOn(responseButtons) = 1;
ResponsePixx('StartAtFlip', [], 1, buttonsOn);

for i = 1 : nFramesTotal    
    
    Screen('FillRect', win, bgColor);
    
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
    swapTime = getLastSwap(e);

    % compute startTime
    if i == 1
        e = addEvent(e, 'showStimulus', swapTime);
    end
    
    % log start and end of coherent phase
    if i == nFramesPre + 1
        e = addEvent(e, 'startCoherent', swapTime);
    elseif i == nFramesPre + nFramesCoh + 1;
        e = addEvent(e, 'endCoherent', swapTime);
    end
    
    % check if fixating
    [eyeTracker, fixating] = monitorFixation(eyeTracker);
    if ~fixating
        par.behaviorTimestamp = GetSecs;
        par.abortType = 'eyeAbort';
        e = netAbortTrial(e, par);
        break
    end
    
    % check for response
    buttonPressed = getButtonPress(responseButtons);
    if buttonPressed ~= 0
        ResponsePixx('StopNow', [], [0 0 0 0 0]);
        e = clearScreen(e);
        
        if buttonPressed > 0
            resp = find(responseButtons == buttonPressed, 1);
            e = setTrialParam(e, 'response', resp);
            correct = find(getParam(e, 'signal') == getParam(e, 'signals'));
            isCorrect = resp == correct;
            e = setTrialParam(e, 'correctResponse', isCorrect);
            valid = GetSecs - startTime > delayTime * 1000;
            e = setTrialParam(e, 'validTrial', valid);
            if isCorrect
                e = playSound(e,'correctResponse');
            end
        else
            par.behaviorTimestamp = GetSecs;
            par.abortType = 'buttonAbort';
            e = netAbortTrial(e, par);
        end
        break
    end
end

% log stimulus offset event
e = addEvent(e, 'endStimulus', getLastSwap(e));

% catch trial is performed correctly if subject maintains fixation until
% the end of the trial
if catchTrial
    e = setTrialParam(e, 'response', -1);
    e = setTrialParam(e, 'correctResponse', fixating);
    e = setTrialParam(e, 'validTrial', fixating);
end

if fixating
    eyeTracker = endTrial(eyeTracker);
end

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
