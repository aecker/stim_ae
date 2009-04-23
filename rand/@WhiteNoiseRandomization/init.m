function r = init(r,params)
% AE 2009-03-16

r.n = size(params,2);
r.params = params;
r.pool = params;
r.backup = params;
