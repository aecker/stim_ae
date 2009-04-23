function [p,b] = getPoolBackup(r)

r = struct(r.white);
p = r.pool;
b = r.backup;
