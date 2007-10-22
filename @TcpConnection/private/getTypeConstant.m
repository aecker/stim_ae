function x = getTypeConstant(tcp,type)
% Get integer constant representing given type.
% AE 2007-10-04

switch type
    case 'double', x = 1;
    case {'cell','string'}, x = 2; % array of strings
    case 'int32', x = 3;
    case 'char', x = 4;            % single string = array of char
    otherwise, error('TcpConnection:getTypeConstant', ...
                     'Unknown type %s!',type)
end
