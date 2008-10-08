function e = FleHumanExperiment(startNow)
% Human flash-lag experiment
% AE 2008-10-08

e.tex = [];

% Create class object
t = TrialBasedExperiment(NoRandomization,StimulationData);
e = class(e,'FleHumanExperiment',t);

% Prepare experiment
if nargin > 0 && startNow
    e = openWindow(e);
    e = tcpMainListener(e);
end
