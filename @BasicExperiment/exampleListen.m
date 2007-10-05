sockcon = pnet('tcpsocket', 1234);
con = pnet(sockcon,'tcplisten');

pnetGetStructElem(con)
