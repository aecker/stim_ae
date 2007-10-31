function r = set(r,field,value)

switch field
    case {'numSubBlocks','movingTrials','initMapTrials','mapTrials'}
        r.(field) = value;
    otherwise
        error('Unknown field %s!',field)
end
