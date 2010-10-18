function [e,retInt32,retStruct,returned] = netShowStimulus(e,params)

% some member variables
win = get(e,'win');
rect = Screen('Rect',win);

% read parameters
movie = e.movie;
clipStartTime = getParam(e,'clipStartTimes');
clipLength = getParam(e,'clipLength');
location = getParam(e,'location');
stimTime = getParam(e,'stimulusTime');
postStimTime = getParam(e,'postStimulusTime');
magnification = getParam(e,'magnification');

if clipLength > stimTime
  error('Clip is too long to be displayed.')
end

% set time to desired start
Screen('SetMovieTimeIndex', movie, clipStartTime);

% size of the movie and magnification
frameSize = e.frameSize;
centerX = mean(rect([1 3])) + location(1);
centerY = mean(rect([2 4])) + location(2);

if magnification < 0    % show full screen movie
    ratios = rect(3:4)./frameSize;
    magnification = min(ratios);
end

destRect = magnification * ...
            [-frameSize(1) -frameSize(2) frameSize(1) frameSize(2)]/2 + ...
            [centerX centerY centerX centerY];
    
% return function call
tcpReturnFunctionCall(e,int32(0),struct,'netShowStimulus');

% start movie playback
Screen('PlayMovie', movie, 1, 0, 0.0);

% intializations
startTime = GetSecs;
times = NaN(10,1);
i = 1; 
running = true;
first = true;

while running
    
  % check for abort signal
  [e,abort] = tcpMiniListener(e,{'netAbortTrial','netTrialOutcome'});
  if abort
      fprintf('stimulus was aborted.......\n')
      break
  end

  % get next movie frame
  [tex times(i)] = Screen('GetMovieImage', win, movie, 1); 
  
  % check whether a valid texture was returned  
  if tex<=0
    error('Invalid texture returned.')
  end;

  % draw the texture on the screen
  Screen('DrawTexture',win,tex,[],destRect,0,[],1); 
  e = swap(e);
  
  % close the texture
  Screen('Close',tex);

  % compute startTime
  if first
      startTime = getLastSwap(e);
      e = addEvent(e,'showStimulus',startTime);
      first = false;
  end
  
  % compute timeout
  running = (getSecs - startTime) < clipLength;
  % running = (Screen('GetMovieTimeIndex', movie) - clipStartTime) < clipLength;
  
  i = i + 1;
end

e = setTrialParam(e,'presentedStimTimes',times);

% keep fixation spot after stimulus turns off
if ~abort

    drawFixSpot(e);
    e = swap(e);

    % log stimulus offset event
    e = addEvent(e,'endStimulus',getLastSwap(e));

    while (GetSecs-startTime)*1000 < stimTime+postStimTime;
        % check for abort signal
        [e,abort] = tcpMiniListener(e,{'netAbortTrial','netTrialOutcome'});
        if abort
            break
        end
    end
    
    if ~abort
        e = clearScreen(e);
    end
else
    % log stimulus offset event
    e = addEvent(e,'endStimulus',getLastSwap(e));
end

Screen('CloseMovie',movie);

% return values
retInt32 = int32(0);
retStruct = struct;
returned = true;

