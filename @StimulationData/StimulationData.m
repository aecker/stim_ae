function data = StimulationData
% Container for storing data about visual stimulation
%
% AE 2007-10-08

% Changes
% AE 2007-10-01: implemented the three different types of parameters
% AE 2007-02-21: initial implementation


%% Parameters
data.params.constants = struct;
data.params.conditions = struct;
data.params.trials = struct;


%% Events
data.eventTypes = {};
data.eventSites = [];
data.events = struct;


%% internal fields
% create directory for temporary storage of trial data
data.folder = '';
data.fallback = '';

% default trial (used when a new trial gets started)
data.defaultTrial = struct;
data.initialized = false;

% create class object
data = class(data,'StimulationData');
