function [e,retInt32,retStruct,returned] = netShowStimulus(e,params)
% Moving and flashed bars for Flash-Lag effect electrophysiology.
% AE 2008-09-02

% find out which stimulus to show
flash = getParam(e,'isFlashTrial');
if flash
    e = showFlashedBar(e,params);
else
    e = showMovingBar(e,params);
end

% return values
retInt32 = int32(0);
retStruct = struct;
returned = true;
