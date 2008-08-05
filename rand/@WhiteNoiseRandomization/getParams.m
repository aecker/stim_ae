function [params,r] = getParams(r,n)
% Return n params from the pool.
% AE & MS 2008-07-14

% How many locations are available
k = size(r.pool,2);
rnd = randperm(k);

% less locations available than asked for
% => use the remaining and refill pool
if k < n
    params1 = r.pool(:,rnd);
    r = refillPool(r);
    [params2,r] = getParams(r,n-k);
    params = [params1, params2];
    return
end

% select a random subset
params = r.pool(:,rnd(1:n));

% remove selected from pool
r.pool(:,rnd(1:n)) = [];
