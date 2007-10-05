function field = get(e,fieldName)
% return parameter structure

switch fieldName
    case {'data','soundWaves'}
        field = e.(fieldName);
    otherwise
        field = get(e.BasicExperiment,fieldName);
end
