function e = MovingBarExperiment
% Simple moving bar experiment
% AE & PhB 2007-09-28

e.tex = [];

% Create class object
t = TrialBasedExperiment(MovingBarRandomization,StimulationData);
e = class(e,'MovingBarExperiment',t);


% Prepare experiment
if nargin > 0 && startNow
    e = openWindow(e);
    e = tcpMainListener(e);
end

