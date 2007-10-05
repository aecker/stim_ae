function [e,abort] = checkForAbort(e)
% MOVE TO BASICEXP, RENAME TO pnetMiniListener.  This function will
% now take in a list of function calls to execute, all others will call
% run time errors to be called
% Check if a remote abort signal has been sent and interpret it.
% AE 2007-02-21

% non-blocking read from the network buffer
con = get(e,'con');
fctName = pnet(con,'readline',2^16,'view','noblock');

% in case buffer is non-empty, we call the function
if ~isempty(fctName)
    % clear read buffer and abort
    pnet(con,'readline');
    e = feval(fctName,e);
    abort = true;
else
    abort = false;
end
