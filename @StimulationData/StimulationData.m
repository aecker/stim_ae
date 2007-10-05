function data = StimulationData(eventNames,eventSites,varargin)
% Container for storing data about visual stimulation.
% AE 2007-02-21

data.eventNames = eventNames;
data.eventSites = eventSites;

% Here we put the data of the currently running trial
% Fields used by TrialBasedExperiment should be initialized here to make
% sure that they cannot be used by derived Experiment types
maxEvents = length(eventNames);
data.curTrial.condition = [];
data.curTrial.events = zeros(1,maxEvents);
data.curTrial.eventTimes = zeros(1,maxEvents);
data.curTrial.validTrial = true;
data.curTrial.sync = [];
data.nEvents = 0;

% Add dynamic fields. This can be used by derived Experiment types to put
% data into the structure
if nargin > 2
    f = fieldnames(varargin{1});
    for i = 1:length(f)
        if any(strmatch(f{i},fieldnames(data.curTrial)))
            error('%s is a default fieldname and cannot be used.',f{i})
        else
            data.curTrial.(f{i}) = varargin{1}.(f{i});
        end
    end
end

% Keep a memory of default trial. This will be used to initialize the
% curTrial field for the next trial at the end of a trial.
data.defaultTrial = data.curTrial;

% Here we put the completed trials
data.trials = repmat(data.curTrial,1,0);

% create class object
data = class(data,'StimulationData');
