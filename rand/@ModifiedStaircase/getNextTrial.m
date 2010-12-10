function [r,cond] = getNextTrial(r)
% Return condition for next trial.
% AE 2008-09-03

% randomly draw stimulus intensity for the next trial
level = r.distribution(r.threshold);
level = min(level,r.maxLevel);

% did we show this stimulus level before?
levelNdx = find(r.levels == level,1);
if isempty(levelNdx)
    levelNdx = numel(r.levels) + 1;
    r.levels(levelNdx) = level;
    r.pools{levelNdx} = getNewPool(r);
end

% are there both types of condition in the pool?
if numel(unique(r.pools{levelNdx})) < 2
    r.pools{levelNdx} = [r.pools{levelNdx} getNewPool(r)];
end

% now draw a random condition
condNdx = ceil(rand(1) * numel(r.pools{levelNdx}));
cond = r.pools{levelNdx}(condNdx);

% remember current condition
r.currentLevel = levelNdx;
r.currentCondition = condNdx;

str = {'Counter-Clockwise','Clockwise'};
fprintf('Level: %3d | %17s | ',level,str{cond})
