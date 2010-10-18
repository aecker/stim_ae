function e = FlashLagExperiment
% Flash lag experiment
% AE 2010-10-16

e.tex = [];

% Create class object
t = TrialBasedExperiment(ReportPerceptRandomization,StimulationData);
e = class(e,'FlashLagExperiment',t);
