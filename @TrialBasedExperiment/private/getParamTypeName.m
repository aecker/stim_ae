function typeName = getParamTypeName(e,typeConstant)
% Return integer constant represeting parameter type.
% AE 2007-10-04

switch typeConstant
    case 1, typeName = 'constants';
    case 2, typeName = 'conditions';
    case 3, typeName = 'trials';
    otherwise, error('TrialBasedExperiment:getParamTypeName', ...
                    'Unknown parameter type constant "%d"',typeConstant)
end
