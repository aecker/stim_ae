function data = StimulationData(constants,conditions,perTrial,eventNames,eventSites)
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
data.params.constants = parseVarArgs(constants,'startTime',now,'endTime',[]);
data.params.conditions = conditions;
data.defaultTrial.params = parseVarArgs(perTrial,'condition',[]);
data.params.trials = repmat(data.defaultTrial.params,0,0);

% make sure subject name is passed
if isempty(data.constant.subject)
    error('StimulationData:init','Constant ''subject'' missing!')
end


%% Events
data.eventTypes = eventTypes;
data.eventSites = eventSites;
data.events.types = {};
data.events.times = {};


%% internal fields
% create directory for temporary storage of trial data
subject = data.constants.subject;
date = datestr(data.constants.startTime,'YYYY-mm-dd HH-MM-SS');
data.folder = getLocalPath(sprintf('/stor01/stimulation/%s/%s',subject,date));
data.fallback = sprintf('~/stimulation/%s',date);
mkdir(data.fallback)

% default trial parameters (used when a new trial gets started)
data.defaultTrial.events = struct('types',{},'times',{});
data.defaultTrial.params = [];

% create class object
data = class(data,'StimulationData');
