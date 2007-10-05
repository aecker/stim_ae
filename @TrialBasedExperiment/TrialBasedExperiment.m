function e = TrialBasedExperiment()
% Base class to derive trial-based experiments.

e.params = [];
e.paramTypes = [];
e.randomization = [];
e.soundWaves = [];
e.data = [];

e = class(e,'TrialBasedExperiment',BasicExperiment);

