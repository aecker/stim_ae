function [r, mustStop] = trialCompleted(r, valid, varargin)
% AE 2012-11-26

% trial successfully completed -> remove condition from pool
if valid
    biasNdx = r.current.bias;
    bias = r.pools.bias(biasNdx);
    signalNdx = r.current.signal;
    signal = r.pools.signal{bias}{1}(signalNdx);
    coherenceNdx = r.current.coherence;
    coherence = r.pools.coherence{bias, signal}(coherenceNdx);
    
    r.pools.signal{bias}{1}(signalNdx) = [];
    r.pools.coherence{bias, signal}(coherenceNdx) = [];
    r.pools.seed{bias, signal, coherence}(r.current.seed) = [];
    
    % subblock done?
    if isempty(r.pools.signal{bias}{1})
        r.pools.signal{bias}(1) = [];
    end

    % block done?
    if isempty(r.pools.signal{bias})
        r.pools.bias(:, r.current.bias) = [];
        r = nextBlock(r);
    end
end

mustStop = false;
