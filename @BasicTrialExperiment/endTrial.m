function e = endTrial(e)
% End of trial.

% notify randomization whether trial successful
validTrial = get(e.data,'validTrial');
[e.randomization,lastTrial] = trialCompleted(e.randomization,validTrial);

% retrieve clock synchronization data for this trial from sync buffer
[e,sync] = getSyncTimes(e);
e.data = set(e.data,'sync',sync(1));

% Store data
e.data = set(e.data,'validTrial',validTrial);
e.data = storeTrial(e.data);

% notify state system whether last trial or we need more
pnet(get(e,'con'),'write',uint8(lastTrial));
