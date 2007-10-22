function tcpReturnFunctionCall(e,retInt32,retStruct)

if get(e,'debug')
    return
end

s = dbstack;
returnFunctionCall(e.tcpConnection,s(2).name,retInt32,retStruct);
