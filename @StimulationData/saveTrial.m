function data = saveTrial(data)
% Save current trial.
% AE 2007-10-05

% save to local disk (this is only for backup purposes in case of a crash)
params = data.params.trials(end);
events = data.events(end);
fileName = sprintf('%s/%.4d.mat',data.fallback,length(data.trials));
save(fileName,'params','events');
