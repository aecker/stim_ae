function e = FashLagExperiment(startNow)
% Flash lag experiment
% AE 2007-10-17

e.photoDiodeTimer = PhotoDiodeTimer;
e.tex = [];

% Create class object
t = TrialBasedExperiment(NoRandomization,StimulationData);
e = class(e,'FlashLagExperiment',t);


% Prepare experiment
if nargin > 0 && startNow
    e = openWindow(e);
    e = tcpMainListener(e);
end
