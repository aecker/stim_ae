function r = init(r, params)
% Initialize randomization

r.params = params;

% initialize pools
nBiases = size(params.biases, 2);
nSignals = numel(params.signals);
nCoherences = numel(params.coherences);
r.pools.signal = cell(1, nBiases);
r.pools.coherence = cell(nBiases, nSignals + 1);
r.pools.seed = cell(nBiases, nSignals + 1, nCoherences);

% start first block
r = nextBlock(r);
