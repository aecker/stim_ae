function e = MovingBarExperiment
% Simple moving bar experiment
% AE & PhB 2007-09-28

e.tex = [];

% Create class object
t = TrialBasedExperiment(MovingBarRandomization,StimulationData);
e = class(e,'MovingBarExperiment',t);
