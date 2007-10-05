function [e,retInt32,retStruct,returned] = netAddEvent(e,params)
% Get timestamp of an event that occured on the state system (e.g. monkey
% acquiring fixation, recieving reward etc.) and store it in the data
% structure.

e.data = addEvent(e.data,params.eventName,params.timeStamp);
retInt32 = int32(0);
retStruct = struct;
returned = false;
