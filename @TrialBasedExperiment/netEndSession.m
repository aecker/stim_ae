function [e,retInt32,retStruct,returned] = netEndSession(e,params)
% Finalize session, i.e. write data to disk.
% AE 2007-002-22

% set end time
e.data = setEndTime(e.data,now);

% Convert local timestamps to state system time
e.data = convertTimeStamps(e.data);

% write data to disk
err = saveData(e.data);

retInt32 = int32(err);
retStruct = struct;
returned = false;
