function [params,r] = getParams(r,n)
% Return n params from the pool.
% AE & MS 2008-07-14

% Due to recursion limits in Matlab with this cide we can only return a
% limited number of parameters at once. A solution to this problem would be
% to flatten the recursion in this function to a loop.
assert(size(r.params,2) * 500 > n,'You can''t request that many parameters at the same time. See comment in this function.')

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
