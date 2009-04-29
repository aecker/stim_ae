function [types,sites] = getEventTypes(e)
% Here we add some custom events only used by the FlePhysExperimentV2.
% AE 2009-03-15

% first get all events defined by the parent class
[types,sites] = getEventTypes(e.TrialBasedExperiment);

% and now add our own ones
% show/endSubStimulus mark onset and offset of single stimuli (of which we
% have multiple per trial)
types = [types; {'showSubStimulus'; 'endSubStimulus'}];

% Site that triggers the above events (0 = Mac/Matlab; 1 = PC/LabView)
sites = [sites, 0, 0];
