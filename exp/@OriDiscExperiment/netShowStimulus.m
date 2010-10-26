function [e,retInt32,retStruct,returned] = netShowStimulus(e,varargin)
% Show stimulus
% AE 2010-10-24

win = get(e,'win');

% stimulus parameters
monitorCenter = getParam(e,'monitorCenter');
location = monitorCenter + getParam(e,'location');
phase = getParam(e,'phase');      
spatialFreq = getParam(e,'spatialFreq');
orientation = getParam(e,'orientation');

% draw stimulus
period = 1 / spatialFreq;
phase = (phase / 360 * period) - (period / 2);
x = -phase * sin(orientation / 180 * pi);
y = phase * cos(orientation / 180 * pi);
rect = [location - e.textureSize / 2 + [x; y]; ...
        location + e.textureSize / 2 + [x; y]];
Screen('DrawTexture',win,e.texture,[],rect,orientation);
Screen('DrawTexture',win,e.alphaMask);

% draw response targets
leftTarget = monitorCenter + getParam(e,'leftTarget');
rightTarget = monitorCenter + getParam(e,'rightTarget');
targetColor = getParam(e,'targetColor');
targetSize = getParam(e,'targetSize');
if getParam(e,'correctTargetOnly')
    if (orientation - getParam(e,'centerOrientation')) > 0
        x = rightTarget;
    else
        x = leftTarget;
    end
else
    x = [leftTarget rightTarget];
end
Screen('DrawDots',win,x,targetSize,targetColor,[],1);

% fixation spot and buffer swap
drawFixSpot(e);
e = swap(e);

% record start time
e = addEvent(e,'showStimulus',getLastSwap(e));

% return values
retInt32 = int32(0);
retStruct = struct;
returned = false;

