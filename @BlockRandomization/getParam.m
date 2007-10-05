function value = getParam(r,paramName,condIndex)
% Get parameter value for given condition.
% AE 2007-10-05

value = r.conditions(condIndex).(paramName);
