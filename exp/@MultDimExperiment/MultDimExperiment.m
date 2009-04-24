function e = MultDimExperiment(varargin)
% Multidimensional coding experiment.
% AE 2008-12-18

% Some variables we need to precompute the stimulus
e.textures = [];
e.textureSize = [];
e.gammaTables = [];
e.alphaMask = [];
e.alphaMaskSize = [];
e.alphaDiskSize = [];

t = TrialBasedExperiment(MultDimRandomization,StimulationData);
e = class(e,'MultDimExperiment',t);

% Prepare experiment
if nargin > 0 && startNow
    e = openWindow(e);
    e = tcpMainListener(e);
end
