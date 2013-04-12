function [e,retInt32,retStruct,returned] = netShowFixSpot(e, varargin)
% This function displays the fixation spot, as requested by Labview
%
% e = netShowFixSpot(e,params)

% Put fixation spot
win = get(e, 'win');
Screen('FillRect', get(e, 'win'),getParam(e, 'bgColor'));
monitorCenter = getParam(e, 'monitorCenter');
fixSpotSize = getParam(e, 'fixSpotSize');
fixSpotLocation = monitorCenter + getParam(e, 'fixSpotLocation');
biases = getParam(e, 'biases');
r = get(e, 'randomization');
bias = biases(:, getBias(r));
fixSpotColor = 255 * [bias / max(bias); 0];
Screen('DrawDots', win, fixSpotLocation, fixSpotSize, fixSpotColor, [], 1);
e = swap(e);

% store timestamp
e = addEvent(e, 'showFixSpot', getLastSwap(e));

retInt32 = int32(0);
retStruct = struct;
returned = false;
