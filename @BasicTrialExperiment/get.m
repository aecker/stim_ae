function field = get(e,fieldName)
% return parameter structure

switch fieldName
    case {'params','curParams','curIndex','soundWaves'}
        field = e.(fieldName);
    otherwise
        field = get(e.BasicExperiment,fieldName);
end
