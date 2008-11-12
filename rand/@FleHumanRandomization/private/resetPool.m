function r = resetPool(r)

% regular blocks
pool = {};
for i = 1:r.maxBlockSize
    pool{end+1} = find([r.conditions.blockSize] == i &  ...
                       [r.conditions.blockType] == FleHumanRandomization.REGULAR_BLOCK); %#ok<AGROW>
end

% probe blocks
for i = 2:r.maxBlockSize
    cond = find([r.conditions.blockSize] == i &  ...
                [r.conditions.blockType] == FleHumanRandomization.PROBE_BLOCK);
    ndx = 1:2:2*i;
    % randomly select which trial in the block is going to be probe trial
    rnd = ceil(rand(1) * (i-1)); 
    ndx(rnd) = 2*rnd;
    pool{end+1} = cond(ndx); %#ok<AGROW>
end

r.conditionPool = [pool{randperm(length(pool))}];
r.currentTrial = 1;
