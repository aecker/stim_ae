function val = getParam(data,paramName)
% Get parameter value.
% AE 2007-10-05

if isfield(data.params.constants,paramName)
    val = data.params.constants.(paramName);

elseif isfield(data.params.trials,paramName)
    val = data.params.trials(end).(paramName);

elseif isfield(data.params.conditions,paramName)
    condNdx = data.params.trials(end).condition;
    val = data.params.conditions(condNdx).(paramName);

else
    error('StimulationData:getParam','No such parameter: %s',paramName)
end
