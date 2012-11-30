function [types,sites] = getEventTypes(e)
% Here we add some custom events.
% AE 2011-09-19

% first get all events defined by the parent class
[types,sites] = getEventTypes(e.WNOriDiscExperiment);

% and now add our own one for eye tracker start
types = [types; {'eyeTrackerStart'; 'buttonAbort'}];

% Site that triggers the above events (0 = Mac/Matlab; 1 = PC/LabView)
sites = [sites, 0, 0];
