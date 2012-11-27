function [types, sites] = getEventTypes(e)
% Add custom events used by WNOriDetectExperiment.
% AE 2012-11-27

% first get all events defined by the parent class
[types, sites] = getEventTypes(e.TrialBasedExperiment);

% and now add our own ones
types = [types; {'startCoherent'; 'endCoherent'}];

% Site that triggers the above events (0 = Mac/Matlab; 1 = PC/LabView)
sites = [sites, 0, 0];
