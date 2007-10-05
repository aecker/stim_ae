function c = getParamTypeConstant(e,paramType)
% Return integer constant represeting parameter type.
% AE 2007-10-04

switch paramType
    case 'constant', c = 1;
    case 'condition', c = 2;
    case 'trial', c = 3;
    otherwise, error('TrialBasedExperiment:getParamTypeConstant', ...
                    'Unknown parameter type "%s"',paramType)
end
