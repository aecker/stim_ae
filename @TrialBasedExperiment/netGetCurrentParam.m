function [e,retInt32,retStruct,returned] = netGetCurrentParam(e,params)
% Query current parameters.
%    This function is used by the labView state system to get the 
%    parameters used in the current trial.
%
% AE 2007-02-21

for i = 1:length(params.paramNames)
    retStruct.(paramNames{i}) = getParam(e.data,params.paramNames{i});
end
retInt32 = int32(0);
returned = false;
