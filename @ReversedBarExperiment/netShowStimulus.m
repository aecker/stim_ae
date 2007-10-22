function [e,retInt32,retStruct,returned] = netShowStimulus(e,params)
% Show stimulus.
% AE & PhB 2007-10-09

% as this is a non-blocking function call from LabView, we have to return it
% manually
% tcpReturnFunctionCall(e,int32(0),struct);

% show stimulus depending on which block were in
if getParam(e,'isInitMapping')
    e = showFlickeringBar(e);
elseif getParam(e,'isNormal')
    e = showMovingBar(e);
else
    switch getParam(e,'exceptionType')
        case 'reverse'
            e = showReversedBar(e);
        case 'stop'
            e = showStoppedBar(e);
    end
end

retInt32 = int32(0);
retStruct = struct;
returned = true;
