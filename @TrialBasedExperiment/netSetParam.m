function [e,retInt32,retStruct,returned] = netSetParam(e,params)
% Remotely set experimental parameters.
% AE 2007-10-05

type = getParamTypeName(e,params.type);
e.params.(type).(params.name) = params.value;

retInt32 = int32(0);
retStruct = struct;
returned = false;
