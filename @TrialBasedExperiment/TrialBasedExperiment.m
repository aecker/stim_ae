function e = TrialBasedExperiment(randomization,stimulationData)
% Base class to derive trial-based experiments.

e.params.constants = struct;
e.params.conditions = struct;
e.params.trials = struct;

e.randomization = randomization;
e.data = stimulationData;

e.soundWaves = [];

e = class(e,'TrialBasedExperiment',BasicExperiment);
