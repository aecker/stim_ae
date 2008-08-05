function [e,retInt32,retStruct,returned] = netShowStimulus(e,params)
% Show stimulus.
% AE & MS 2008-07-17

% some member variables..
win     = get(e,'win');
refresh = get(e,'refreshRate'); % Monitor refresh rate ~= 100 Hz
tex     = get(e,'tex');

% parameters
barColor   = getParam(e,'barColor');
barAngle   = getParam(e,'barAngle');
barLength  = getParam(e,'barLength');
barWidth   = getParam(e,'barWidth');
stimFrames = getParam(e,'stimFrames');
stimCenter = [getParam(e,'stimCenterX'); getParam(e,'stimCenterY')];
delayTime  = getParam(e,'delayTime');
nBars = fix(barLength / barWidth);
len = nBars  * barWidth;

% compute number of frames
flipInterval = 1000 / refresh; % frame duration in msec ~= 10 msec
m = ceil(delayTime / flipInterval);
nFrames = ceil(m / stimFrames);

% precompute bar locations, orientations, and colors
random = get(e,'randomization');
[tmp,random] = getParams(random,nFrames);
e = set(e,'randomization',random);
locs = (tmp(1,:) - 0.5) * barWidth;
cols = tmp(2,:);

% initialize
abort = false;
firstTrial = true;
frames = 0;
i = 0;
%  ret = struct('correctResponse',int32(1));
%  tcpReturnFunctionCall(e,int32(0),ret,'netShowStimulus');
% stimulation loop
for k = 1:stimFrames*nFrames
    
    % check for abort signal
    [e,abort] = tcpMiniListener(e,{'netAbortTrial','netTrialOutcome'});
    if abort
        break
    end

    % new location after n frames
    if frames == 0
        i = i+1;
        frames = stimFrames;

        % determine bar position
        angle = barAngle / 180 * pi;
        startPos = stimCenter - len/2 * [sin(angle); cos(angle)];
        pos = startPos + locs(i) * [sin(angle); cos(angle)];
        barSize2 = [barLength; barWidth] / 2;
        rect = [pos - barSize2; pos + barSize2];
    end
    
    % draw bar
    Screen('DrawTexture',win,tex(cols(i)),[],rect,-barAngle); 

    % draw photodiode spot; do buffer swap and keep timestamp
    drawFixspot(e);
    e = swap(e);
    
    % first trial needs to be treated separately
    if firstTrial

        % return function call
        ret = struct('correctResponse',int32(1));
        tcpReturnFunctionCall(e,int32(0),ret,'netShowStimulus');

        % compute startTime
        startTime = getLastSwap(e);
        e = addEvent(e,'showStimulus',startTime);
        firstTrial = false;
    end
    
    % update number of frames the stimulus is still there
    frames = frames - 1;
end

% clear screen (abort clears the screen anyway in netAbortTrial, so skip it
% in this case)
if ~abort
    e = clearScreen(e);
end

% log stimulus offset event
e = addEvent(e,'endStimulus',getLastSwap(e));

% Get rid of empty cells and save spot locations and colors
e = setTrialParam(e,'barLocations',locs(1:i));
e = setTrialParam(e,'barColors',barColor(cols(1:i)));

% return values
retInt32 = int32(0);
retStruct = struct;
returned = true;

