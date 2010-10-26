function pool = getNewPool(r)
% Return new pool of conditions.
% AE 2010-10-24

pool = repmat(1:2,1,r.poolSize/2);
