function conditions = getConditions(r)
% Get struct array  containing all conditions.
% AE 2012-11-26

coherences = r.params.coherences;
nCoherence = numel(coherences);
seeds = r.params.seeds;
nSeeds = numel(seeds);
signals = r.params.signals;
nSignals = numel(signals); % plus catch trials
locations = r.params.locations;
nLocations = numel(locations);

for i = 1 : nSignals
    for j = 1 : nLocations
        for k = 1 : nCoherence
            for l = 1 : nSeeds
                c.signal = signals(i);
                c.location = locations(:, j);
                c.coherence = coherences(k);
                c.seed = seeds(l);
                c.isCatchTrial = false;
                conditions(i, j, k, l) = c; %#ok
            end
        end
    end
end
conditions = reshape(conditions, [], 1);
c.signal = NaN;
c.location = NaN;
c.coherence = NaN;
c.isCatchTrial = true;
for k = 1 : nSeeds
    c.seed = seeds(k);
    conditions(end + 1) = c; %#ok
end
