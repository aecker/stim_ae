function field = get(e,fieldName)
% return parameter structure

switch fieldName
    case {'win','con','refreshRate','debug'}
        field = e.(fieldName);
    otherwise
        error('no suich field!')
end
