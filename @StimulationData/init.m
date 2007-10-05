function data = init(data,expType,constants,conditions,perTrial)
% Initialize StimulationData object.
%    This should be done at startSession when all parameters, their values, and
%    the different conditions are known.
%
% AE 2007-10-01

% parameters
data.params.constants = parseVarArgs(constants,'expType',expType,'startTime',now);
data.params.conditions = conditions;
data.defaultTrial.params = parseVarArgs(perTrial,'condition',[]);

% make sure subject name is passed
if isempty(data.constant.subject)
    error('StimulationData:init','Constant ''subject'' missing!')
end
