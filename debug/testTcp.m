function testTcp(port)
% Test UDP connection...

con = pnet('tcpconnect','localhost',port);
pnet(con,'printf','%s\n','testTiming');
timeStamp = pnet(con,'readline');
disp(timeStamp)
pnet(con,'close')
