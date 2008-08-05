function e = BarMappingExperiment(startNow)
% Receptive field mapping with bars
% AE & MS 2008-07-17

% Create class object
t = TrialBasedExperiment(BarMappingRandomization,StimulationData);
e.tex = [];
e = class(e,'BarMappingExperiment',t);

% Prepare experiment
if nargin > 0 && startNow
    e = openWindow(e);
    e = tcpMainListener(e);
end
