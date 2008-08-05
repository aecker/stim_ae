function [e,retInt32,retStruct,returned] = showStimulusDots(e,params)
% Show Random dots
% Mani May-16-2008
% May-28-2008
% some member variables..
win     = get(e,'win');
refresh = get(e,'refreshRate'); % Monitor refresh rate ~= 100 Hz
flipInterval = 1000/refresh; % frame duration in msec ~= 10 msec
%--------------------------------------------------------------------------
% parameters
dotColorDark     = getParam(e,'dotColorDark');
dotColorBright   = getParam(e,'dotColorBright');
dotSize          = getParam(e,'dotSize');
dotSize          = round(dotSize);
dotFrames        = getParam(e,'dotFrames');
dotRangeCenter   = getParam(e,'dotRangeCenter');
dotRange         = getParam(e,'dotRange');
stimulusTime     = getParam(e,'stimulusTime');
nDots            = getParam(e,'nDots');
%--------------------------------------------------------------------------
% return function call
tcpReturnFunctionCall(e,int32(0),struct('correctResponse',int32(1)),'netShowStimulus');
%--------------------------------------------------------------------------
m = ceil(stimulusTime/flipInterval);
nFrames = ceil(m/dotFrames);
justInCaseFrames = 5;
totalFrames = nFrames + justInCaseFrames;
% Preallocate cell arrays for speed
dotColors = cell(1,totalFrames);
dotLocations = cell(1,totalFrames);
%--------------------------------------------------------------------------
% Precompute common factors to increase speed
offset = dotRangeCenter - 0.5*dotRange;
offset = repmat(offset,[1 nDots]);
rangeMat = repmat(dotRange,[1,nDots]);
%--------------------------------------------------------------------------
% Precompute dot color and locations
for t = 1:totalFrames
    % Assign dot colors randomly
    b = rand(1,nDots)>0.5;
    brightNdark = b*dotColorBright + (1-b)*dotColorDark;
    dotColors{t} = repmat(brightNdark,[3,1]);
    % Assign random positions
    dotLocations{t} = offset + ceil(rangeMat.*rand(2,nDots));
end
%--------------------------------------------------------------------------
% initialize
abort = false;
firstTrial = true;
frames = 0;
i = 0;
T = GetSecs;
endTime = inf;
%--------------------------------------------------------------------------
% stimulation loop
while T < endTime
    drawFixspot(e);
    % check for abort signal
    [e,abort] = tcpMiniListener(e,{'netAbortTrial','netTrialOutcome'});
    if abort
        break
    end
    if frames==0
        i = i+1;
        frames = dotFrames;
    end
    % draw black/white rectangles
    Screen('DrawDots',win,dotLocations{i},dotSize,dotColors{i},[0,0],0);
    % draw photodiode spot; do buffer swap and keep timestamp
    e = swap(e);
    % compute startTime
    if firstTrial
        startTime = getLastSwap(e);
        e = addEvent(e,'showStimulus',startTime);
        endTime = startTime + stimulusTime/1000;
        firstTrial = false;
    end
    frames = frames-1;  % update number of frames the stimulus is still there
    T = GetSecs;
end
%--------------------------------------------------------------------------
% clear screen (abort clears the screen anyway in netAbortTrial, so skip it in
% this case)
if ~abort
    e = clearScreen(e);
end
%--------------------------------------------------------------------------
% Get rid of empty cells and save spot locations and colors
e = setTrialParam(e,'dotLocations',dotLocations(1:i));
e = setTrialParam(e,'dotColors',dotColors(1:i));
%--------------------------------------------------------------------------
% return values
retInt32 = int32(0);
retStruct = struct;
returned = true;
%--------------------------------------------------------------------------
