function e = abortTrial(e)
% Abort current trial.

% Read and store reason for and timestamp of the abort
con = get(e,'con');
abortType = pnet(con,'readline');
timeStamp = pnet(con,'read',1,'double');
e.data = addEvent(e.data,abortType,timeStamp);

% clear screen
e = clearScreen(e);

% Set abort status
e.data = set(e.data,'validTrial',false);

% get sound vectors
e = playSoundLocal(e,soundType);
