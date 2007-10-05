function [e,retInt32,retStruct,returned] = netSetParams(e,params)
% Set parameter for the current trial.
%     Note that this will also affect all future trials until a new parameter
%     value is set.
%
% AE 2007-10-05

e.data = setTrialParam(e.data,params.name,params.value);

retInt32 = int32(0);
retStruct = struct;
returned = false;
