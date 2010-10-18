function r = putBackPreviousCondition(r)
% Put previously polled condition back into pool.
%   r = putBackPreviousCondition(r)
%
% AE 2009-03-16

r.white = r.whiteBackup;
