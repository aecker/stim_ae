function r = putBackLastCondition(r)
% Put previously polled condition back into pool.
%   r = putBackLastCondition(r)
%
% AE 2009-03-16

r.white = r.whiteBackup;
