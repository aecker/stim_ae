function e = NatImExperiment(varargin)
% Natural image experiment.
% AE/LG/GD 2013-07-10

% Some variables we need to precompute the stimulus
e.textures = [];
e.textureSize = [];
e.destRect = [];
e.gammaTables = [];
e.alphaMask = [];
e.alphaMaskSize = [];
e.alphaDiskSize = [];

t = TrialBasedExperiment(NatImRandomization, StimulationData);
e = class(e, 'NatImExperiment', t);

% Prepare experiment
if nargin > 0 && startNow
    e = openWindow(e);
    e = tcpMainListener(e);
end
