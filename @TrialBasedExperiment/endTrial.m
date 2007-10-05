function e = endTrial(e)
% End of trial.

% notify randomization whether trial successful
validTrial = get(e.data,'validTrial');
correctTrial = get(e.data,'correctResponse');

[e.randomization,lastTrial] = trialCompleted(e.randomization,validTrial,correctTrial);

%validTrial = get(getTrialData(e),'correctResponse');
%[e.randomization,lastTrial] = trialCompleted(e.randomization,validTrial);


% retrieve clock synchronization data for this trial from sync buffer
% [e,sync] = getSyncTimes(e);
% e.data = set(e.data,'sync',sync(1));
% removed this sync

% Store data
e.data = set(e.data,'validTrial',validTrial);
e.data = storeTrial(e.data);

% Save data in between trials
c = getConditions(e.randomization);
paramNames = fieldnames(e.params);
[m,n] = size(c);
for i = 1:m
    for j = 1:n
        conditions(i).(paramNames{j}) = e.params.(paramNames{j})(c(i,j));
    end
end

% Convert local timestamps to state system time
e.data = convertTimeStamps(e.data);

% write data to disk
saveData(e.data,class(e),'temp',date,'conditions',conditions);

disp(sprintf(['LastTrial: ' num2str(lastTrial)]))

% notify state system whether last trial or we need more
pnet(get(e,'con'),'write',uint8(lastTrial));
