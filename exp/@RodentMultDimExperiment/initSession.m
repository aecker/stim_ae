function e = initSession(e,params,expType)

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
e.MultDimExperiment = initSession(e.MultDimExperiment,params,expType);

% make sure photodiode object has large enough buffer
e = set(e,'photoDiodeTimer',PhotoDiodeTimer(params.stimulusTime/1000*60,[0 255],50));
