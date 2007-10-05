function [e,retValI32,retStruct] = netIsExecuting(e,params)
% Remote query if non-blocking function call is still executing.
%    This function will always return false since in case the function is
%    still executing, the tcpMiniListener will catch this function call and
%    immediately return true.
%
% AE 2007-10-04

retValI32 = int32(0);
retStruct = struct;
