function field = get(e,fieldName)
% return parameter structure

switch fieldName
    case 'tex'
        field = e.(fieldName);
    otherwise
        field = get(e.TrialBasedExperiment,fieldName);
end
