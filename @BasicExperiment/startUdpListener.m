function e = startTcpListener(e)
% Start listening for TCP commands.

% open socket
e.con = pnet('udpsocket',e.port);
pnet(e.con,'udpconnect','128.249.85.51',1234);

% start listening for command
while true
    
    % read udp packet
    pnet(e.con,'readpacket');
    
    % read and parse command
    command = pnet(e.con,'readline');
    if ~isempty(command)
        e = feval(command,e);
    end
end

% end of session, close connection
pnet(e.con,'close');
