function [e,abort] = tcpMiniListener(e,allowedFunctions)
% Listen for remote function calls during non-blocking functions.
%     [exp,abort] = tcpMiniListener(exp,{'netAbortTrial','netRemoveStimulus'})
%     will listen for remote function calls and execute them. Remote
%     function calls can either be 'isExecuting' to query whether the
%     non-blocking function that was called by LabView is still running or
%     one of the function names passed to the tcpMiniListener.
%
% AE 2007-10-04

% read out remote function call (if there is any)
[fctName,params] = getFunctionCall(e.tcpConnection);
abort = false;
if isempty(fctName)
    return 
end

% catch isExecuting request
if strcmp(fctName,'netIsExecuting')
    returnFunctionCall(e.tcpConnection,fctName,int32(1),struct);
    return
end

% make sure valid function is called
if isempty(strmatch(fctName,allowedFunctions))
    s = dbstack;
    exp = class(e);
    error('BasicExperiment:tcpMiniListener', ...
          'Invalid remote function call (%s) during %s:%s!', ...
          fctName,exp,s(2).name)
end

% execute function call
[e,retValI32,retStruct,abort] = feval(fctName,e,params);
returnFunctionCall(e.tcpConnection,fctName,retvalI32,retStruct);
