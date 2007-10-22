function e = set(e,fieldName,value)

switch fieldName
    case {'randomization','data','params','soundWaves'}
        e.(fieldName) = value;
    otherwise
        e.BasicExperiment = set(e.BasicExperiment,fieldName,value);
end
