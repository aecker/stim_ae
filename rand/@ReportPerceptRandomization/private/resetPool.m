function r = resetPool(r)

% regular blocks
pool = {};
for i = 1:r.maxBlockSize
    pool{end+1} = find([r.conditions.blockSize] == i &  ...
                       [r.conditions.blockType] == ReportPerceptRandomization.REGULAR_BLOCK);
end

% probe blocks
if r.expMode
    for i = 2:r.maxBlockSize
        cond = find([r.conditions.blockSize] == i &  ...
                    [r.conditions.blockType] == ReportPerceptRandomization.PROBE_BLOCK);
        ndx = 1:2:2*i;
        rnd = ceil(rand(1) * (i-1));
        ndx(rnd) = 2*rnd;
        pool{end+1} = cond(ndx);
    end
end

r.conditionPool = [pool{randperm(length(pool))}];
r.currentTrial = 1;
