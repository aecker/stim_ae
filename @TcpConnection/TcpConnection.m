function tcp = TcpConnection(port)
% TCP network connection wrapper.
% JC & AE 2007-10-04

if nargin < 1, port = 1234; end
tcp.port = port;
tcp.socket = [];
tcp.con = 0;
tcp.host = [];
tcp = class(tcp,'TcpConnection');
