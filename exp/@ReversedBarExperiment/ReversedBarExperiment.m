function e = ReversedBarExperiment(startNow)
% Simple moving bar experiment
% AE & PhB 2007-09-28

e.photoDiodeTimer = PhotoDiodeTimer;
e.tex = [];
e.texInvisible = [];

% Create class object
t = TrialBasedExperiment(ReversedBarRandomization,StimulationData);
e = class(e,'ReversedBarExperiment',t);


% Prepare experiment
if nargin > 0 && startNow
    e = openWindow(e);
    e = tcpMainListener(e);
end
