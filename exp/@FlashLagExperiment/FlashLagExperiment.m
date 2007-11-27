function e = FlashLagExperiment(startNow)
% Flash lag experiment
% AE 2007-10-17

e.tex = [];

% Create class object
t = TrialBasedExperiment(ReportPerceptRandomization,StimulationData);
e = class(e,'FlashLagExperiment',t);


% Prepare experiment
if nargin > 0 && startNow
    e = openWindow(e);
    e = tcpMainListener(e);
end
