function r = init(r, params)
% Initialize randomization

r.params = params;

% initialize pools
nBiases = size(params.biases, 2);
nSignals = numel(params.signals);
nLocations = numel(params.locations);
nCoherences = numel(params.coherences);

% feature or spatial task?
assert(nSignals == 1 || nLocations == 1, 'Either signal or location needs to be scalar!')
features = {'signal', 'location'};
r.feature = features{1 + (nLocations > 1)};

r.pools.signal = cell(1, nBiases);
r.pools.location = cell(1, nBiases);
r.pools.coherence = cell(nBiases, nSignals * nLocations + 1);
r.pools.seed = cell(nBiases, nSignals * nLocations + 1, nCoherences);

% start first block
r = nextBlock(r);
