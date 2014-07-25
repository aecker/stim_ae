function condition = getConditionByIndex(r, signal, location, coherence, seed)
% Return condition number given the indices for signal, location, coherence
% and seed.
% AE 2012-11-27

nCoherences = numel(r.params.coherences);
nSeeds = r.params.nSeeds;
nSignals = numel(r.params.signals);
nLocations = numel(r.params.locations);
condition = sub2ind([nSignals nLocations nCoherences, nSeeds], signal, location, coherence, seed);
