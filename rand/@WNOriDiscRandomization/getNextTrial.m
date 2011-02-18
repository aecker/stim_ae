function [r,condIndex] = getNextTrial(r)
% AE 2011-02-18

% determine signal condition
[r.stair,signalIndex] = getNextTrial(r.stair);

% randomly draw stimulus intensity for the next trial
level = getLevel(r.stair);
levelIndex = find(r.levels == level);
if isempty(levelIndex)
    
    % if it wasn't shown before, add this level
    r.levels(end+1) = level;
    levelIndex = length(r.levels);
    
    % initialize randomizations dealing with fixed or random seeds, phases
    % and noise
    for i = 1:numel(r.signals)
        r.seedRand{i,levelIndex} = r.newSeedRand;
        K = r.fixedSeedNum > 0;
        for j = 1:K+1
            r.phaseRand{i,levelIndex,j} = r.newPhaseRand;
        end
        for j = 1:numel(r.phases)
            r.noiseRand{i,levelIndex,j} = r.newNoiseRand;
        end
    end
end

% determine whether fixed or random seed trial
sr = r.seedRand{signalIndex,levelIndex};
sr = getNextTrial(sr);
[seedIndex,sr] = getParams(sr,1);
r.seedRand{signalIndex,levelIndex} = sr;

% determine which spatial phase to show
pr = r.phaseRand{signalIndex,levelIndex,seedIndex};
pr = getNextTrial(pr);
[phaseIndex,pr] = getParams(pr,1);
r.phaseRand{signalIndex,levelIndex,seedIndex} = pr;

% also start trial for noise randomization
r.noiseRand{signalIndex,levelIndex,phaseIndex} = getNextTrial(r.noiseRand{signalIndex,levelIndex,phaseIndex});

% determine condition index
fixedSeed = [false true];
cond = struct('signal',r.signals(signalIndex), ...
              'fixedSeed',fixedSeed(seedIndex), ...
              'phase',r.phases(phaseIndex));
condIndex = find(arrayfun(@(x) isequal(x,cond),r.conditions));

% current parameters
r.curCondIndex = condIndex;
r.curSignalIndex = signalIndex;
r.curLevelIndex = levelIndex;
r.curSeedIndex = seedIndex;
r.curPhaseIndex = phaseIndex;
