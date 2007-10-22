function field = get(e,fieldName)
% return parameter structure

switch fieldName
    case {'randomization','data','params','soundWaves'}
        field = e.(fieldName);
    otherwise
        field = get(e.BasicExperiment,fieldName);
end
