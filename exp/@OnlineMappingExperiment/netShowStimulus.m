function [e,retInt32,retStruct,returned] = netShowStimulus(e,params)
% Show stimulus.
% PHB 2007-11-24


exp = getParam(e,'stimulus');

switch exp
    case 'MovingBar'
        [e,retInt32,retStruct,returned] = showStimulusMovingBar(e,params);   
    case 'SparseDot'
        [e,retInt32,retStruct,returned] = showStimulusSparseDot(e,params);   
    case 'FlashedBar'
        [e,retInt32,retStruct,returned] = showStimulusFlashingBars(e,params);   
end
