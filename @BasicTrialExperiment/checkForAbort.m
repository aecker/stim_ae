function [e,abort] = checkForAbort(e)
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
