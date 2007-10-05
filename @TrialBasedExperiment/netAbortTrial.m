function [e,retInt32,retStruct,returned] = netAbortTrial(e,params)
% Abort current trial.

e.data = addEvent(e.data,params.abortType,params.timeStamp);
e.data = setTrialParam(e.data,'validTrial',false);

% Screen needs to be cleared here (e.g. in order to remove fixation spot if
% abort happend during initial fixation period).
e = clearScreen(e);
e = playSound(e,params.abortType);

retInt32 = int32(0);
retStruct = struct;
returned = false;
