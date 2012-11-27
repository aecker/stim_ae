function condition = getConditionByIndex(r, signal, coherence, seed)
% Return condition number given the indices for signal, coherence and seed.
% AE 2012-11-27

nCoherences = numel(r.params.coherences);
nSeeds = r.params.nSeeds;
nSignals = numel(r.params.signals);
if signal <= nSignals
    condition = sub2ind([nSignals nCoherences, nSeeds], signal, coherence, seed);
else
    condition = nSignals * nCoherences * nSeeds + seed;
end
