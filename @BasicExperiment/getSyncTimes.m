function [e,sync] = getSyncTimes(e)
% Retrieve times stored in the synchronization buffer. Note that a call to this
% function clears the buffer.
%
% AE 2007-02-22

sync = e.sync(1:end-1);
e.sync = e.sync(end);
