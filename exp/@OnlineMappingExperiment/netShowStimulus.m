function [e,retInt32,retStruct,returned] = netShowStimulus(e,params)
% Show stimulus.
% PHB 2007-11-24


exp = getParam(e,'stimulus');

switch exp
    case 'MovingBar'
        [e,retInt32,retStruct,returned] = showStimulusMovingBar(e,params);   
end