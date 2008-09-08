function e = initTrial(e)
% Initialize trial.
% AE 2008-09-02

% determine number of stimulus frames
refresh = get(e,'refreshRate');
flash = getParam(e,'isFlashTrial');
if flash
    fsTime = getParam(e,'flashStimTime');
    nFrames = ceil(fsTime / 1000 * refresh);
else
    dx = getParam(e,'dx');
    trajLen = getParam(e,'trajectoryLength');
    nFrames = ceil(trajLen / dx);
end

% make sure its symmetric and hits the same locations as the flashes
nLocs = getParam(e,'numFlashLocs');
if mod(nFrames,2) ~= mod(nLocs,2)
    nFrames = nFrames - 1;
end
e = setTrialParam(e,'nFrames',nFrames);

% compute post-stimulus fixation time
stimTime = nFrames * refresh;
delayTime = getParam(e,'delayTime');
e = setTrialParam(e,'stimulusTime',stimTime);
e = setTrialParam(e,'postStimulusTime',delayTime - stimTime);
