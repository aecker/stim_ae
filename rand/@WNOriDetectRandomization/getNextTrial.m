function [r, condition] = getNextTrial(r)
% Return parameters for given condition.
% AE 2012-11-27

r.trial = r.trial + 1;

bias = r.pools.bias(r.current.bias);
featureNdx = ceil(rand() * numel(r.pools.(r.feature){bias}{1}));
feature = r.pools.(r.feature){bias}{1}(featureNdx);

% draw random coherence (after refilling pool if necessary)
if isempty(r.pools.coherence{bias, feature})
    r.pools.coherence{bias, feature} = 1 : numel(r.params.coherences);
end
coherenceNdx = ceil(rand() * numel(r.pools.coherence{bias, feature}));
coherence = r.pools.coherence{bias, feature}(coherenceNdx);

% draw random seed (after refilling pool if necessary)
if isempty(r.pools.seed{bias, feature, coherence})
    r.pools.seed{bias, feature, coherence} = 1 : r.params.nSeeds;
end
seedNdx = ceil(rand() * numel(r.pools.seed{bias, feature, coherence}));
seed = r.pools.seed{bias, feature, coherence}(seedNdx);

r.current.feature = featureNdx;
r.current.coherence = coherenceNdx;
r.current.seed = seedNdx;

switch r.feature
    case 'location'
        signal = 1;
        location = feature;
    case 'signal'
        signal = feature;
        location = 1;
end
condition = getConditionByIndex(r, signal, location, coherence, seed);
