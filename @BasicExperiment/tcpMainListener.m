function e = tcpMainListener(e)
% Start listening for TCP commands.
% AE 2007-10-04

% Open socket and wait for connection
e.tcpConnection = startListener(e.tcpConnection);

% Start control loop that will keep looping until the connection is closed
% by the remote host.
while isConnected(e.tcpConnection)

    % read out and execute remote function call
    [fctName,params] = getFunctionCall(e.tcpConnection);
    [e,retValI32,retStruct,returned] = feval(fctName,e,params);

    % Some functions such as showStimulus are non-blocking. They send an
    % aknowledgement to LabView before they actually return and we don't 
    % need to send it here
    if ~returned
        returnFunctionCall(e.tcpConnection,fctName,retvalI32,retStruct);
    end
end

% end of session, close connection
close(e.tcpConnection);

% clean up
cleanUp(e);
