function [e,retInt32,retStruct,returned] = netEndTrial(e,params)
% End of trial.

% notify randomization whether trial successful
validTrial = getParam(e,'validTrial');
correctTrial = getParam(e,'correctResponse');
[e.randomization,canStop,mustStop] = ...
    trialCompleted(e.randomization,validTrial,correctTrial);

% retrieve clock synchronization data for this trial from sync buffer
% [e,sync] = getSyncTimes(e);
% e.data = set(e.data,'sync',sync(1));
% removed this sync
warning('TrialBasedExperiment:netEndTrial', ...
        'Currently no synchronization. Where is it done/should it be done?')

% save data
e.data = saveTrial(e.data);

% notify state system whether experiment can be stopped
% (e.g. this can be used to make sure blocks are fully executed)
% disp(sprintf(['can stop: ' num2str(canStop)]))

retInt32 = int32(0);
retStruct = struct('canStop',canStop,'mustStop',mustStop);
returned = false;
