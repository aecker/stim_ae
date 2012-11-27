function [r, condition] = getNextTrial(r)
% Return parameters for given condition.
% AE 2012-11-27

r.trial = r.trial + 1;

bias = r.pools.bias(r.current.bias);
signalNdx = ceil(rand() * numel(r.pools.signal{bias}{1}));
signal = r.pools.signal{bias}{1}(signalNdx);

% draw random coherence (after refilling pool if necessary)
if isempty(r.pools.coherence{bias, signal})
    if signal == 3
        k = 1; % catch trial -- no coherent phase...
    else
        k = numel(r.params.coherences);
    end
    r.pools.coherence{bias, signal} = 1 : k;
end
coherenceNdx = ceil(rand() * numel(r.pools.coherence{bias, signal}));
coherence = r.pools.coherence{bias, signal}(coherenceNdx);

% draw random seed (after refilling pool if necessary)
if isempty(r.pools.seed{bias, signal, coherence})
    r.pools.seed{bias, signal, coherence} = 1 : r.params.nSeeds;
end
seedNdx = ceil(rand() * numel(r.pools.seed{bias, signal, coherence}));
seed = r.pools.seed{bias, signal, coherence}(seedNdx);

r.current.signal = signalNdx;
r.current.coherence = coherenceNdx;
r.current.seed = seedNdx;

condition = getConditionByIndex(r, signal, coherence, seed);
