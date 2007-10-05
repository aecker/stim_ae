function [e,retInt32,retStruct,returned] = netSetParams(e,params)
% Remotely set experimental parameters.
% AE 2007-10-05

% make sure the minimum amount of parameters is set.
assertCorrectParams(e,params);
e.params = params;

retInt32 = int32(0);
retStruct = strutc;
returned = false;
