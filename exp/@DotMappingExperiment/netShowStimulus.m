function [e,retInt32,retStruct,returned] = netShowStimulus(e,varargin)
% Show stimulus.
% AE & MS 2008-07-14

% some member variables..
win     = get(e,'win');
refresh = get(e,'refreshRate'); % Monitor refresh rate ~= 100 Hz
flipInterval = 1000/refresh; % frame duration in msec ~= 10 msec

%--------------------------------------------------------------------------
% parameters
dotColor   = getParam(e,'dotColor');
dotSize    = getParam(e,'dotSize');
dotNumX    = getParam(e,'dotNumX');
dotNumY    = getParam(e,'dotNumY');
stimFrames = getParam(e,'stimFrames');
stimCenter = [getParam(e,'stimCenterX'); getParam(e,'stimCenterY')];
delayTime  = getParam(e,'delayTime');
pFill      = getParam(e,'pFill');

%--------------------------------------------------------------------------
m = ceil(delayTime / flipInterval);
nFrames = ceil(m / stimFrames);
% Preallocate cell arrays for speed
dotColors = cell(1,nFrames);
dotLocations = cell(1,nFrames);

%--------------------------------------------------------------------------
% sparse or dense dots?
nFill = fix(nFrames * pFill);
actLoc = zeros(dotNumX,dotNumY,nFrames);
actCol = actLoc;
if nFill > 2
    fprintf('Dense dots\n\n')
    for i = 1:dotNumX
        for j = 1:dotNumY
            rnd = randperm(nFrames);
            actLoc(i,j,rnd(1:nFill)) = 1;
            actCol(i,j,rnd(1:nFill)) = 1 + (rand(1,nFill) > 0.5);
        end
    end
else
    fprintf('Sparse dots\n\n')
    random = get(e,'randomization');
    nFill = max(1,round(pFill * dotNumX * dotNumY)); % at least one dot
    for i = 1:nFrames
        [tmp,random] = getParams(random,nFill);
        for j = 1:size(tmp,2)
            actLoc(tmp(1,j),tmp(2,j),i) = 1;
            actCol(tmp(1,j),tmp(2,j),i) = tmp(3,j);
        end
    end
    e = set(e,'randomization',random);
end

%--------------------------------------------------------------------------
% initialize
abort = false;
firstFrame = true;
frames = 0;
i = 0;

%--------------------------------------------------------------------------
% stimulation loop
for k = 1:stimFrames*nFrames
    
    % check for abort signal
    [e,abort] = tcpMiniListener(e,{'netAbortTrial','netTrialOutcome'});
    if abort
        break
    end

    if frames == 0
        i = i+1;
        ndx = find(actLoc(:,:,i));
        [x,y] = ind2sub([dotNumX,dotNumY],ndx);
        x = x' - (dotNumX + 1) / 2;
        y = y' - (dotNumY + 1) / 2;
        dotLocations{i} = bsxfun(@plus,stimCenter,dotSize * [x; y]);
        col = actCol(:,:,i);
        dotColors{i} = dotColor(col(ndx));
        frames = stimFrames;
    end
    
    % draw black/white rectangles
    for j = 1:size(dotLocations{i},2)
        rect = [dotLocations{i}(:,j) - ceil(dotSize/2) * ones(2,1); ...
                dotLocations{i}(:,j) + fix(dotSize/2) * ones(2,1)];
        Screen('FillRect',win,dotColors{i}(j),rect);
    end
    
    % draw photodiode spot; do buffer swap and keep timestamp
    drawFixSpot(e);
    e = swap(e);
    
    % compute startTime
    if firstFrame

        % return function call
        tcpReturnFunctionCall(e,int32(0),struct('correctResponse',int32(1)),'netShowStimulus');

        startTime = getLastSwap(e);
        e = addEvent(e,'showStimulus',startTime);
        firstFrame = false;
    end
    frames = frames-1;  % update number of frames the stimulus is still there
end

%--------------------------------------------------------------------------
% clear screen (abort clears the screen anyway in netAbortTrial, so skip it
% in this case)
if ~abort
    e = clearScreen(e);
end

% log stimulus offset event
e = addEvent(e,'endStimulus',getLastSwap(e));

%--------------------------------------------------------------------------
% Get rid of empty cells and save spot locations and colors
e = setTrialParam(e,'dotLocations',dotLocations(1:i));
e = setTrialParam(e,'dotColors',dotColors(1:i));

%--------------------------------------------------------------------------
% return values
retInt32 = int32(0);
retStruct = struct;
returned = true;

