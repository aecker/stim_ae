function data = storeTrial(data)
% Store current trial.
% AE 2007-02-21

% remove extra event elements
ndx = 1:data.nEvents;
data.curTrial.events = data.curTrial.events(ndx);
data.curTrial.eventTimes = data.curTrial.eventTimes(ndx);
data.nEvents = 0;

% dump current trial into list
data.trials(end+1) = data.curTrial;


% reset current trial field
data.curTrial = data.defaultTrial;
