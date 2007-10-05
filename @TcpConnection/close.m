function close(tcp)
% Close TCP connection and open socket.
% AE 2007-10-04

pnet(tcp.con,'close');
pnet(tcp.socket,'close');
