function field = get(e,fieldName)
% return parameter structure

switch fieldName
    case {'win','con'}
        field = e.(fieldName);
    otherwise
        error('no suich field!')
end
