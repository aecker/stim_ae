function e = WNOriDiscExperiment(varargin)
% White noise orientation discrimination for perceptual learning.
% AE 2010-10-13

% Some variables we need to precompute the stimulus
e.texture = [];
e.textureSize = [];
e.alphaMask = [];

% Randomization will be set at netStartSession
t = TrialBasedExperiment(WNOriDiscRandomization,StimulationData);
e = class(e,'WNOriDiscExperiment',t);

% Prepare experiment
if nargin > 0 && startNow
    e = openWindow(e);
    e = tcpMainListener(e);
end
