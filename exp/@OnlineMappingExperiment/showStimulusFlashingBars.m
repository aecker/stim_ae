function [e,retInt32,retStruct,returned] = showStimulusFlashingBars(e,params)
% shows moving bar
% PHB 2007-11-24

% some member variables..
win     = get(e,'win');
refresh = get(e,'refreshRate');

% parameters
barSize          = getParam(e,'barSize');
len              = getParam(e,'trajectoryLength');
trajectoryAngles = getParam(e,'trajectoryAngles');
trajectoryCenter = getParam(e,'trajectoryCenter');
barColorDark     = getParam(e,'barColorDark');
barColorBright   = getParam(e,'barColorBright');
delayTime        = getParam(e,'delayTime');
barFrames        = getParam(e,'barFrames');

% select angle of trajectory
angle = trajectoryAngles(ceil(rand * length(trajectoryAngles)));

% generate dot textures in both colors
barColorDark = ones(3,1)*barColorDark;
texMat = permute(repmat(barColorDark,[1; barSize]),[2 3 1]);
barTexDark = Screen('MakeTexture',get(e,'win'),texMat);

barColorBright = ones(3,1)*barColorBright;
texMat = permute(repmat(barColorBright,[1; barSize]),[2 3 1]);
barTexBright = Screen('MakeTexture',get(e,'win'),texMat);

% return function call
tcpReturnFunctionCall(e,int32(0),struct,'netShowStimulus');

% determine starting position
angle = angle / 180 * pi;
startPos = trajectoryCenter - len/2 * [cos(angle); -sin(angle)];

% put start time
i = 1;
m = ceil(delayTime/refresh);
s = zeros(m,1);
r = zeros(m,1);
abort = false;
firstTrial = true;
running = true;
currTex = barTexBright;

while running

	drawFixspot(e);

    % check for abort signal
    [e,abort] = tcpMiniListener(e,{'netAbortTrial','netTrialOutcome'});
    if abort
        break
    end
      
    % change position only every couple frames
    if mod(i-1,barFrames)==0
        s(i) = rand(1) * len;       % new position
        texRand = rand > .5;        % new color
        if texRand
            currTex = barTexBright;
        else
            currTex = barTexDark;
        end
    else
        s(i) = s(i-1);
    end
    pos = startPos + s(i) * [cos(angle); -sin(angle)];
    
    % draw colored rectangle
    rect = [pos - barSize/2; pos + barSize/2];
    Screen('DrawTexture',win,currTex,[],rect,-angle*180/pi); 
      
    % draw photodiode spot; do buffer swap and keep timestamp
    e = swap(e);
    
    % compute startTime
    if firstTrial
        startTime = getLastSwap(e);
        e = addEvent(e,'showStimulus',startTime);
        firstTrial = false;
    end
    
    % compute timeOut
    running = (getLastSwap(e)-startTime) < delayTime;

    r(i)=texRand;
    i = i+1;
end

% clear screen (abort clears the screen anyway in netAbortTrial, so skip it in
% this case)
if ~abort
    e = clearScreen(e);
end

% log stimulus offset event
e = addEvent(e,'endStimulus',getLastSwap(e));

% save bar locations
e = setTrialParam(e,'flashBarLocations',s(1:i-1));
e = setTrialParam(e,'flashBarTexture',r);
e = setTrialParam(e,'flashBarTextureBright',barTexBright);
e = setTrialParam(e,'flashBarTextureDark',barTexDark);
e = setTrialParam(e,'flashBarAngle',angle);

% return values
retInt32 = int32(0);
retStruct = struct;
returned = true;
