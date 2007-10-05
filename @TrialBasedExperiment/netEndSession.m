function [e,retInt32,retStruct,returned] = netEndSession(e,params)
% Finalize session.
% AE 2007-10-05

e.data = setEndTime(e.data,now);
e.data = convertTimeStamps(e.data);
err = saveData(e.data);

retInt32 = int32(err);
retStruct = struct;
returned = false;
