function e = DotMappingExperiment(startNow)
% Receptive field mapping experiment using dots
% AE & MS 2008-07-15

% to store textures
e.tex = [];

% Create class object
t = TrialBasedExperiment(WhiteNoiseRandomization,StimulationData);
e = class(e,'DotMappingExperiment',t);

% Prepare experiment
if nargin > 0 && startNow
    e = openWindow(e);
    e = tcpMainListener(e);
end
