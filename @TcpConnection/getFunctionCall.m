function [functionName,params] = getFunctionCall(tcp,blocking)
%{INT32:function_name_length}{CHAR_ARRAY:function_name}{INT32:number_of_parameters}{parameters_data}

% in case of non-blocking, check if there is anything in the buffer and
% return if buffer is empty
if strcmp(blocking,'noblock') && ...
    isempty(pnet(con,'read',1,'char',[],'view','noblock')
    functionName = [];
    params = [];
    return
end

% function name
functionNameLength = double(pnet(tcp.con,'read',1,'int32'))
functionName = pnet(tcp.con,'read',functionNameLength,'char')

% parameters
numParams = double(pnet(tcp.con,'read',1,'int32'))
params = struct;
for i = 1:numParams
    params = getStructElem(tcp,params)
end    
