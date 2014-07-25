function r = nextBlock(r)
% Move to next bias block
% AE 2012-11-26

% get bias for next block
if isempty(r.pools.bias)
    r.pools.bias = 1 : size(r.params.biases, 2);
end
r.current.bias = ceil(rand() * numel(r.pools.bias));
bias = r.pools.bias(r.current.bias);

% below we roughly balance the two signals/locations within the block
biasVal = r.params.biases(:, bias);
nRepsPerBlock = r.params.nRepsPerBlock;
nCoherences = numel(r.params.coherences);
N1 = biasVal(1) * nCoherences * nRepsPerBlock;
N2 = biasVal(2) * nCoherences * nRepsPerBlock;
N = N1 + N2;
S1 = (0.01 * rand(1, N1) + (0 : N1 - 1)) / N1;
S2 = (0.01 * rand(1, N2) + (0 : N2 - 1)) / N2;
[foo, order] = sort([S1, S2]);
feature = [ones(1, N1), 2 * ones(1, N2)];
feature = feature(order);

% split up into smaller blocks
subBlockSize = r.params.subBlockSize;
nSubBlocks = ceil(N / subBlockSize);
r.pools.(r.feature){bias} = cell(1, nSubBlocks);
for i = 1 : nSubBlocks
    first = (i - 1) * subBlockSize + 1;
    last = min(i * subBlockSize, N);
    r.pools.(r.feature){bias}{i} = feature(first : last);
end
