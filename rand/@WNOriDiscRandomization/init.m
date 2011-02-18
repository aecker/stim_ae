function r = init(r,params)
% AE 2011-02-18

r.fixedSeedNum = params.fixedSeedNum;
r.randSeedNum = params.randSeedNum;
r.phases = params.phases;
r.orientations = params.orientations;
r.signals = params.signals;

% initialize staircase randomization
r.stair = init(ModifiedStaircase,params);

% include trials with fixed seed?
fixedSeed = {false};
if r.fixedSeedNum > 0
    fixedSeed{2} = true;
end

% build condition structure
r.conditions = struct('signal',{},'fixedSeed',{},'phase',{});
for signal = r.signals
    for seed = fixedSeed
        for phase = r.phases
            r.conditions(end+1) = ...
                struct('signal',signal,'fixedSeed',seed,'phase',phase);
        end
    end
end

% default randomization to select fixed-seed vs. random-seed trials
% (there is one of these for each signal condition and level)
fixedSeed = [ones(1,r.randSeedNum) 2*ones(1,r.fixedSeedNum)];
r.newSeedRand = init(WhiteNoiseRandomization,fixedSeed);

% default phase randomization
% (there is one of these for each signal condition, level, and seed type)
r.newPhaseRand = init(WhiteNoiseRandomization,(1:numel(r.phases)));

% default noise randomization
orientations = repmat(r.orientations,1,params.oriBlockSize);
r.newNoiseRand = init(WhiteNoiseRandomization,orientations);
