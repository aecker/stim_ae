function e = startTcpListener(e)
% Start listening for TCP commands.
% RENAME TO pnetStartMainListener(e), modify it to call
% the pnetGetFunctionCall
% Open socket and wait for connection
socket = pnet('tcpsocket',e.port);
fprintf('\n* Waiting for connection on port %d\n',e.port);
e.con = pnet(socket,'tcplisten');
ip = pnet(e.con,'gethost');
fprintf('* Host %d.%d.%d.%d connected\n\n',ip);

% Start TCP listening process
% -------------------------------------------------------------------------
% * A control loop is started that will keep looping until the connection
%   is closed by the remote host.
% * In order to call a function from the remote site we send the function
%   name as a string terminated by a linefeed character '\n'.
while pnet(e.con,'status')
    fctName = pnet(e.con,'readline');
     fprintf('* fctName = %s \n', fctName);
    if ~isempty(fctName)
        e = feval(fctName,e);
    end
end

% end of session, close connection
pnet(e.con,'close');
pnet(socket,'close');

% clean up
cleanUp(e);
