function r = init(r,params)
% AE 2008-12-18

% initialize BlockRandomization to get all conditions
r.block = init(BlockRandomization,params);

% create WhiteNoiseRandomizations
cond = getConditions(r.block);
r.white = setParams(WhiteNoiseRandomization,1:numel(cond));
