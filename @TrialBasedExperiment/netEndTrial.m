function [e,retInt32,retStruct,returned] = netEndTrial(e,params)
% End of trial.

% notify randomization whether trial successful
validTrial = get(e.data,'validTrial');
correctTrial = get(e.data,'correctResponse');
[e.randomization,lastTrial] = trialCompleted(e.randomization,validTrial,correctTrial);

% retrieve clock synchronization data for this trial from sync buffer
% [e,sync] = getSyncTimes(e);
% e.data = set(e.data,'sync',sync(1));
% removed this sync

% save data
e.data = storeTrial(e.data);

% notify state system whether last trial or we need more
disp(sprintf(['LastTrial: ' num2str(lastTrial)]))
pnet(get(e,'con'),'write',uint8(lastTrial));
