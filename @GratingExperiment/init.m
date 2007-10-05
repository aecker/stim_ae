function g = init(g)
% Initalization. (I.e. generate textures in this case)
% AE 2007-02-21

% first call parent's init function
g.TrialBasedExperiment = init(g.TrialBasedExperiment);

% generate textures
g = generateTextures(g);
