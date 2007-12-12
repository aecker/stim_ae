function e = GratingExperiment(varargin)
% Simple grating experiment with block randomization.


% Some variables we need to precompute the stimulus
e.textures = [];
e.textureSize = [];
e.alphaMask = [];

t = TrialBasedExperiment(BlockRandomization,StimulationData);
e = class(e,'GratingExperiment',t);

% Prepare experiment
if nargin > 0 && startNow
    e = openWindow(e);
    e = tcpMainListener(e);
end
