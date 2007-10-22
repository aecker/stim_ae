function e = set(e,field,value)

switch field
    case {'debug'}
        e.(field) = value;
end
