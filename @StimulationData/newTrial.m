function data = newTrial(data)
% Create new trial.
% AE 2007-10-01

% make sure it was initialized
if ~data.initialized
    error('StimulationData:newTrial', ...
          'StimulationData object has to be initialized first!.')
end

% create new trial
data.events(end+1) = data.defaultTrial.events;
data.params.trials(end+1) = data.defaultTrial.params;
