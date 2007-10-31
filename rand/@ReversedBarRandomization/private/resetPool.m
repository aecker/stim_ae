function r = resetPool(r)
% Reset condition pool.
% AE 2007-10-05

pool = [repmat([2,3],1,r.nNormalTrials), 4:length(r.conditions)];
r.conditionPool = pool(randperm(length(pool)));
