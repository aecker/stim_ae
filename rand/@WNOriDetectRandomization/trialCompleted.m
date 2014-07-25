function [r, mustStop] = trialCompleted(r, valid, varargin)
% AE 2012-11-26

% trial successfully completed -> remove condition from pool
if valid
    biasNdx = r.current.bias;
    bias = r.pools.bias(biasNdx);
    featureNdx = r.current.feature;
    feature = r.pools.(r.feature){bias}{1}(featureNdx);
    coherenceNdx = r.current.coherence;
    coherence = r.pools.coherence{bias, feature}(coherenceNdx);
    
    r.pools.(r.feature){bias}{1}(featureNdx) = [];
    r.pools.coherence{bias, feature}(coherenceNdx) = [];
    r.pools.seed{bias, feature, coherence}(r.current.seed) = [];
    
    % subblock done?
    if isempty(r.pools.(r.feature){bias}{1})
        r.pools.(r.feature){bias}(1) = [];
    end

    % block done?
    if isempty(r.pools.(r.feature){bias})
        r.pools.bias(:, r.current.bias) = [];
        r = nextBlock(r);
    end
end

mustStop = false;
