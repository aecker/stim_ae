function [e,retInt32,retStruct,returned] = netEndTrial(e,params)
% End of trial.

% notify randomization whether trial successful
validTrial = getParam(e,'validTrial');
correctTrial = getParam(e,'correctResponse');
[e.randomization,lastTrial] = trialCompleted(e.randomization,validTrial,correctTrial);

% retrieve clock synchronization data for this trial from sync buffer
% [e,sync] = getSyncTimes(e);
% e.data = set(e.data,'sync',sync(1));
% removed this sync

% save data
e.data = saveTrial(e.data);

% notify state system whether last trial or we need more
disp(sprintf(['LastTrial: ' num2str(lastTrial)]))

retInt32 = int32(lastTrial);
retStruct = struct;
returned = false;
