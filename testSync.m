function con = testSync(con)

if nargin == 0
    con = pnet('tcpconnect','128.249.85.55',1234);
end

succ = 0;
while succ == 0
    pnet(con,'printf','syncInit\n');
    pnet(con,'write',GetSecs*1000);
    succ = pnet(con,'read',1,'uint8');
end

WaitSecs(0.5)

succ = 0;
while succ == 0
    pnet(con,'printf','syncFinal\n');
    pnet(con,'write',GetSecs*1000);
    succ = pnet(con,'read',1,'uint8');
end
