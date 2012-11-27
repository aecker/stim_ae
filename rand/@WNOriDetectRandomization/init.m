function r = init(r, params)
% Initialize randomization

r.params = params;

% draw random seeds
rand('state', now * 1000);
r.params.seeds = ceil(rand(1, params.nSeeds) * 1e6);

% initialize pools
nBiases = size(params.biases, 2);
nSignals = numel(params.signals);
nCoherences = numel(params.coherences);
r.pools.signal = cell(1, nBiases);
r.pools.coherence = cell(nBiases, nSignals + 1);
r.pools.seed = cell(nBiases, nSignals + 1, nCoherences);

% start first block
r = nextBlock(r);
