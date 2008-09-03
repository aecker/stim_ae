function e = FlePhysExperiment(varargin)
% Moving and flashed bars for FLE electrophysiology.
% AE 2008-09-02

% bar texture handle
e.tex = [];

% real randomization is put at initialization
t = TrialBasedExperiment(NoRandomization,StimulationData);
e = class(e,'FlePhysExperiment',t);

% Prepare experiment
if nargin > 0 && startNow
    e = openWindow(e);
    e = tcpMainListener(e);
end
