function e = OnlineMappingExperiment(startNow)
% OnlineMappingExperiment for initial phase of recording
% PHB 2007-11-24

e.tex = [];

% Create class object
t = TrialBasedExperiment(NoRandomization,StimulationData);
e = class(e,'OnlineMappingExperiment',t);


% Prepare experiment
if nargin > 0 && startNow
    e = openWindow(e);
    e = tcpMainListener(e);
end
