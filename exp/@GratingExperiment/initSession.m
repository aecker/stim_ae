function e = initSession(e,params,expType)
% Initalization. (I.e. generate textures in this case)

% first call parent's init function
e.TrialBasedExperiment = initSession(e.TrialBasedExperiment,params,expType);

% generate textures
e = generateTextures(e);
