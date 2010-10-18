function r = init(r,params)
% AE 2010-10-17

% initialize BlockRandomization to get all conditions
r.block = init(r.block,params);

% create WhiteNoiseRandomizations
cond = getConditions(r.block);
r.white = setParams(r.white,1:numel(cond));
