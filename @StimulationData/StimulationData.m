function data = StimulationData(eventNames,eventSites)
% Container for storing data about visual stimulation
%
% AE 2007-10-04

% Changes
% AE 2007-10-01: implemented the three different types of parameters
% AE 2007-02-21: initial implementation


%% Parameters
% parameters that are constant throughout the session.
% date, subject, and experiment type are mandatory, all others are added when
% the session is started
data.params.constants.expType = [];
data.params.constants.subject = [];
data.params.constants.startTime = [];
data.params.constants.endTime = [];

% parameter sets of different conditions
data.params.conditions = [];

% here we put the trials
data.params.trials = [];


%% Events
data.eventNames = eventNames;
data.eventSites = eventSites;
data.events.types = {};
data.events.times = {};


%% internal fields
% where to store the data on disk
data.folder = [];
data.fallback = [];
data.defaultTrial.events = struct('types',{},'times',{});
data.defaultTrial.params = [];
data.initialized = false;

% create class object
data = class(data,'StimulationData');
