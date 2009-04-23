function [e,retInt32,retStruct,returned] = netStartSession(e,params)

% for 2-photon, we don't need the following settings, so just set them here
params.joystickThreshold = 0;
params.fixationRadius = 0;
params.passive = 1;
params.allowSaccades = 1;
params.acquireFixation = 0;
params.fixSpotLocation = [-1; -1];  % don't need a fixation spot
params.fixSpotSize = 0;
params.fixSpotColor = [0; 0; 0];

% initialize parent
[e.MultDimExperiment,retInt32,retStruct,returned] = ...
    netStartSession(e.MultDimExperiment,params);

% make sure photodiode object has large enough buffer and also a large spot
% alternating color, since we're running full screen gratings
e = set(e,'photoDiodeTimer',PhotoDiodeTimer(params.stimulusTime/1000*60,[0 255],50));
