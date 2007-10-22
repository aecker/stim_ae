function data = init(data,constants,conditions,trials,eventTypes,eventSites)
% Initialize stimulation data container
%
% AE 2007-10-08

%% Parameters
data.params.constants = constants;
data.params.constants.startTime = now;
data.params.constants.entTime = [];

data.params.conditions = conditions;

data.params.trials = trials;
data.params.trials.condition = [];
data.defaultTrial.params = data.params.trials;
data.params.trials = repmat(data.defaultTrial.params,0,0);

% make sure subject name is passed
if isempty(data.params.constants.subject)
    error('StimulationData:init:SubjectMissing','Constant ''subject'' missing!')
end


%% Events
data.eventTypes = eventTypes;
data.eventSites = eventSites;
data.defaultTrial.events = struct('types',[],'times',[]);
data.events = repmat(data.defaultTrial.events,0,0);


%% internal fields
% create directory for temporary storage of trial data
subject = data.params.constants.subject;
date = datestr(data.params.constants.startTime,'YYYY-mm-dd_HH-MM-SS');
data.folder = getLocalPath(sprintf('/stor01/stimulation/%s/%s',subject,date));
data.fallback = sprintf('~/stimulation/%s',date);
mkdir(data.fallback)

data.initialized = true;
