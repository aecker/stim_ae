function [e,retInt32,retStruct,returned] = netShowStimulus(e,params)
% Show stimulus.
% AE & PhB 2007-10-09

% as this is a non-blocking function call from LabView, we have to return it
% manually
% tcpReturnFunctionCall(e,int32(0),struct);

% show stimulus depending on which block were in
if getParam(e,'isMapping')
    e = showFlickeringBar(e);
else
    e = showMovingBar(e);
end

retInt32 = int32(0);
retStruct = struct;
returned = true;
