function [e,retInt32,retStruct,returned] = netShowStimulus(e,params)
% Show stimulus.
% AE & PhB 2007-10-09

fprintf('condition: %d',getParam(e,'condition'));

% show stimulus depending on which block we're in
if getParam(e,'isMapping')
    [e,retInt32,retStruct,returned] = showFlickeringBar(e);
else
    [e,retInt32,retStruct,returned] = showMovingBar(e);
end

