function bias = getBias(r)
% Return current bias.

biasNdx = r.current.bias;
bias = r.pools.bias(biasNdx);
