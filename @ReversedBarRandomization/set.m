function r = set(r,field,value)

switch field
    case {'initMapTrials','exceptionRate'}
        r.(field) = value;
    otherwise
        error('Unknown field %s!',field)
end
