function r = nextBlock(r)
% Move to next bias block
% AE 2012-11-26

% get bias for next block
if isempty(r.pools.bias)
    r.pools.bias = 1 : size(r.params.biases, 2);
end
r.current.bias = ceil(rand() * numel(r.pools.bias));
bias = r.pools.bias(r.current.bias);

% below we balance the difference coherence levels, seeds, and signals
% roughly uniformly within the block
biasVal = r.params.biases(:, bias);
nRepsPerBlock = r.params.nRepsPerBlock;
nCoherences = numel(r.params.coherences);
N1 = biasVal(1) * nCoherences * nRepsPerBlock;
N2 = biasVal(2) * nCoherences * nRepsPerBlock;
Nc = r.params.nCatchPerBlock;
N = N1 + N2 + Nc;

% roughly balance the two signals and the catch trials within the block
S1 = (0.01 * rand(1, N1) + (0 : N1 - 1)) / N1;
S2 = (0.01 * rand(1, N2) + (0 : N2 - 1)) / N2;
Sc = (0.01 * rand(1, Nc) + (0 : Nc - 1)) / Nc;
[~, order] = sort([S1, S2, Sc]);
signal = [ones(1, N1), 2 * ones(1, N2), 3 * ones(1, Nc)];
signal = signal(order);

% split up into smaller blocks
subBlockSize = r.params.subBlockSize;
nSubBlocks = ceil(N / subBlockSize);
r.pools.signal{bias} = cell(1, nSubBlocks);
for i = 1 : nSubBlocks
    first = (i - 1) * subBlockSize + 1;
    last = min(i * subBlockSize, N);
    r.pools.signal{bias}{i} = signal(first : last);
end
