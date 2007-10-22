function data = setTrialParam(data,name,value)
% Set trial-by-trial parameter for current trial.
% AE 2007-10-05

% make sure this is a valid parameter
if isempty(strmatch(name,fieldnames(data.params.trials),'exact'))
    error('StimulationData:setTrialParam', ...
          '"%s" is not a trial-by-trial parameter!',name)
end

data.params.trials(end).(name) = value;
data.defaultTrial.params.(name) = value;
