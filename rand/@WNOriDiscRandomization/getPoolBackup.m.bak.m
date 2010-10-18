function [p,b] = getPoolBackup(r)

r = struct(r.noiseWhite{r.currentCond});
p = r.pool;
b = r.backup;
