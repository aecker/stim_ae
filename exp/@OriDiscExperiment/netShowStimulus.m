function [e,retInt32,retStruct,returned] = netShowStimulus(e,varargin)
% Show stimulus
% AE 2010-10-24

% return function call
tcpReturnFunctionCall(e,int32(0),struct,'netShowStimulus');

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

% target locations
leftTarget = monitorCenter + getParam(e,'leftTarget');
rightTarget = monitorCenter + getParam(e,'rightTarget');
targetColor = getParam(e,'targetColor');
targetSize = getParam(e,'targetSize');
class = getParam(e,'class');
if class
	correct = rightTarget;
	incorrect = leftTarget;
else
	correct = leftTarget;
	incorrect = rightTarget;
end

% draw stimulus
Screen('DrawTexture',win,e.texture,[],rect,orientation);
Screen('DrawTexture',win,e.alphaMask);

% draw response targets at small size
Screen('DrawDots',win,correct,targetSize/2,targetColor,[],1);
Screen('DrawDots',win,incorrect,targetSize/2,targetColor,[],1);

% fixation spot and buffer swap
drawFixSpot(e);
e = swap(e);
startTime = getLastSwap(e);
e = addEvent(e,'showStimulus',startTime);

% wait until delay time is over until we show the saccade targets
cueTime = getParam(e,'cueTime');
abort = false;
while GetSecs < startTime + cueTime / 1000
	% check for abort signal
    [e,abort] = tcpMiniListener(e,{'netAbortTrial','netTrialOutcome'});
    if abort
        break
		else
		fprintf('.')
    end
    WaitSecs(0.01);
end

if ~abort
	% draw stimulus
	Screen('DrawTexture',win,e.texture,[],rect,orientation);
	Screen('DrawTexture',win,e.alphaMask);

	% draw response targets
	Screen('DrawDots',win,correct,targetSize,targetColor,[],1);
	Screen('DrawDots',win,incorrect,targetSize/2,targetColor,[],1);

	% fixation spot and buffer swap
	drawFixSpot(e);
	e = swap(e);
end

% return values
retInt32 = int32(0);
retStruct = struct;
returned = true;

