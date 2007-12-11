function [e,retInt32,retStruct,returned] = showStimulusMovingBar(e,params)
% shows moving bar
% PHB 2007-11-24

% some member variables..
win     = get(e,'win');
refresh = get(e,'refreshRate');

% parameters
barSize          = getParam(e,'barSize');
len              = getParam(e,'trajectoryLength');
speed            = getParam(e,'speed');
trajectoryAngle  = getParam(e,'trajectoryAngle');
trajectoryCenter = getParam(e,'trajectoryCenter');
moveDir = rand(1) > getParam(e,'moveProb');
e = setTrialParam(e,'moveDir',moveDir);

% generate bar texture
texMat = permute(repmat(getParam(e,'barColor'),[1; barSize]),[2 3 1]);
barTex = Screen('MakeTexture',get(e,'win'),texMat);

% return function call
tcpReturnFunctionCall(e,int32(0),struct,'netShowStimulus');



% determine starting position
angle = (trajectoryAngle + 180 * moveDir) / 180 * pi;
startPos = trajectoryCenter - len/2 * [cos(angle); -sin(angle)];

% put start time
firstTrial = true;
n = ceil(len / speed * refresh);
s = zeros(n,1);
pos = startPos;
i = 1;
abort = false;
while s(i) < len

	drawFixspot(e);

    % check for abort signal
    [e,abort] = tcpMiniListener(e,{'netAbortTrial','netTrialOutcome'});
    if abort
        break
    end

    % draw colored rectangle
    rect = [pos - barSize/2; pos + barSize/2];
    Screen('DrawTexture',win,barTex,[],rect,-angle*180/pi); 
      
    % draw photodiode spot; do buffer swap and keep timestamp
    e = swap(e);
    
    % compute timeout
    if firstTrial
        startTime = getLastSwap(e);
        e = addEvent(e,'showStimulus',startTime);
        firstTrial = false;
    end

    i = i+1;
    
    % compute next position
    s(i) = (getLastSwap(e) - startTime + 1 / refresh) * speed;
    pos = startPos + s(i) * [cos(angle); -sin(angle)];
end

% clear screen (abort clears the screen anyway in netAbortTrial, so skip it in
% this case)
if ~abort
    e = clearScreen(e);
end

% save bar locations
e = setTrialParam(e,'movBarLocations',s(1:i-1));
e = setTrialParam(e,'movBarTexture',barTex);

% return values
retInt32 = int32(0);
retStruct = struct;
returned = true;
