function e = ReversedBarExperiment
% Simple moving bar experiment
% AE & PhB 2007-09-28

e.tex = [];
e.texInvisible = [];

% Create class object
t = TrialBasedExperiment(ReversedBarRandomization,StimulationData);
e = class(e,'ReversedBarExperiment',t);
