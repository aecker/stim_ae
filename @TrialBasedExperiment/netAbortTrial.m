function [e,retInt32,retStruct,returned] = netAbortTrial(e,params)
% Abort current trial.

% Read and store reason for and timestamp of the abort
fprintf('entered abortTrial\n')
con = get(e,'con');
abortType = pnet(con,'readline');
disp(sprintf(['got 1st input arg: ' abortType]))
timeStamp = pnet(con,'read',1,'double');
fprintf('got 2nd input arg\n')
e.data = addEvent(e.data,abortType,timeStamp);

% clear screen
e = clearScreen(e);

% Set abort status
e.data = set(e.data,'validTrial',false);

% get sound vectors
e = playSoundLocal(e,abortType);

% confirmation
pnet(con,'write',uint8(1));
fprintf('Wrote confirmation\n')
