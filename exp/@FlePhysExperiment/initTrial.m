function e = initTrial(e)
% Initialize trial.
% AE 2008-09-02

% determine number of stimulus frames
refresh = get(e,'refreshRate');
dx      = getParam(e,'dx');
trajLen = getParam(e,'trajectoryLength');
nLocs   = getParam(e,'numFlashLocs');
nFrames = ceil(trajLen / dx);
% make sure its symmetric and hits the same locations as the flashes
if mod(nFrames,2) ~= mod(nLocs,2)
    nFrames = nFrames - 1;
end
stimTime = nFrames * refresh;

% compute post-stimulus fixation time
delayTime = getParam(e,'delayTime');
e = setTrialParam(e,'stimulusTime',stimTime);
e = setTrialParam(e,'postStimulusTime',delayTime - stimTime);
