function e = WNOriDetectExperiment(varargin)
% White noise orientation detection.
% AE/GD 2012-11-13

% Some variables we need to precompute the stimulus
e.texture = [];
e.textureSize = [];
e.alphaMask = [];

% Randomization will be set at netStartSession
t = TrialBasedExperiment(WNOriDetectRandomization, StimulationData);
e = class(e, 'WNOriDetectExperiment', t);

% Prepare experiment
if nargin > 0 && startNow
    e = openWindow(e);
    e = tcpMainListener(e);
end
