function r = computeConditions(r)
% Compute condition pool.
% AE 2007-10-05

cond = struct('trialIndex',{}, ...
                      'blockSize',{}, ...
                      'blockType',{}, ...
                      'trialType',{});

% 1 trial regular block
cond(end+1) = struct('trialIndex',1, ...
                             'blockSize',1, ...
                             'blockType',FleHumanRandomization.REGULAR_BLOCK, ...
                             'trialType',FleHumanRandomization.REGULAR_REWARD);
                  
for i = 2:r.maxBlockSize
    
    % regular blocks
    for j = 1:i-1
        cond(end+1) = struct('trialIndex',j, ...
                                     'blockSize',i, ...
                                     'blockType',FleHumanRandomization.REGULAR_BLOCK, ...
                                     'trialType',FleHumanRandomization.REGULAR_NO_REWARD); %#ok<AGROW>
    end
    
    % last trial in regular block (here the monkey gets rewarded)
    cond(end+1) = struct('trialIndex',i, ...
                                 'blockSize',i, ...
                                 'blockType',FleHumanRandomization.REGULAR_BLOCK, ...
                                 'trialType',FleHumanRandomization.REGULAR_REWARD); %#ok<AGROW>

    % probe blocks
    for j = 1:i-1
        cond(end+1) = struct('trialIndex',j, ...
                                     'blockSize',i, ...
                                     'blockType',FleHumanRandomization.PROBE_BLOCK, ...
                                     'trialType',FleHumanRandomization.REGULAR_NO_REWARD); %#ok<AGROW>
        cond(end+1) = struct('trialIndex',j, ...
                                     'blockSize',i, ...
                                     'blockType',FleHumanRandomization.PROBE_BLOCK, ...
                                     'trialType',FleHumanRandomization.PROBE); %#ok<AGROW>
    end

    % last trial in probe block (here the monkey gets rewarded)
    cond(end+1) = struct('trialIndex',i, ...
                                 'blockSize',i, ...
                                 'blockType',FleHumanRandomization.PROBE_BLOCK, ...
                                 'trialType',FleHumanRandomization.REGULAR_REWARD); %#ok<AGROW>
end


% init block rands
n = numel(cond);
r.block = BlockRandomization;
for i = 1:n
    if cond(i).trialType == FleHumanRandomization.PROBE
        r.block(i) = init(BlockRandomization,r.subParams);
    else
        r.block(i) = init(BlockRandomization,r.supraParams);
    end
end

% compute all conditions
conditions = cell(1,n);
for i = 1:n
    conditions{i} = getConditions(r.block(i));
    [conditions{i}.trialIndex] = deal(cond(i).trialIndex);
    [conditions{i}.blockSize] = deal(cond(i).blockSize);
    [conditions{i}.blockType] = deal(cond(i).blockType);
    [conditions{i}.trialType] = deal(cond(i).trialType);
end
nCond = [0 cellfun(@numel,conditions)];
r.firstCond = cumsum(nCond(1:end-1));
r.allConditions = [conditions{:}];
r.conditions = cond;
