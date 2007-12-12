function g = init(e,params)
% Initalization. (I.e. generate textures in this case)

% first call parent's init function
e.TrialBasedExperiment = init(e.TrialBasedExperiment);

% generate textures
e = generateTextures(e);
