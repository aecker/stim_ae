function returnFunctionCall(tcp,functionName,retValI32,retStruct)
% Return remote function call.
%    returnFunctionCall(tcpConnection,functionName,retValI32,retStruct)
%    
%    functionName: name of the function that sends the return
%    retValI32: return valus of type int32 (usually some kind of error
%               code)
%    retStruct: more complex return values are returned in a matlab
%               structure. Each field can contain matrices of doubles or
%               int32, or a cell array of strings.
%
% JC & AE 2007-10-04

pnet(tcp.con,'write',int32(length(functionName)));
pnet(tcp.con,'write',functionName);
pnet(tcp.con,'write',int32(retValI32));
writeStruct(tcp,retStruct);
