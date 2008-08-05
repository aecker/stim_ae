function [e,retInt32,retStruct,returned] = showFlickeringBar(e)
% show flickering bars for receptive field mapping.

win =           get(e,'win');
refresh =       get(e,'refreshRate');
barSize =       getParam(e,'barSize');
len =           getParam(e,'trajectoryLength');
angle =         getParam(e,'trajectoryAngle');
trajCenter =    getParam(e,'trajectoryCenter');
mappingTime =   getParam(e,'mapTime');
fpLoc =         getParam(e,'mapFramesPerLoc');


% determine starting position
angle = angle / 180 * pi;
startPos = trajCenter - len/2 * [cos(angle); -sin(angle)];

% return function call
tcpReturnFunctionCall(e,int32(0),struct,'netShowStimulus');

% initialize
startTime = GetSecs;
n = ceil(mappingTime / (1000 / refresh * fpLoc));
s = zeros(1,n);
rect = zeros(4,n);
center = zeros(2,n);
i = 1;
abort = false;
% * 1000 to convert into ms
% minus one frame since after the last iteration of the loop the stimulus will
% stay for one frame until clearScreen()
while (GetSecs - startTime) * 1000 < mappingTime - (1000 / refresh)
    
    drawFixspot(e);
    
    % check for abort signal
    [e,abort] = tcpMiniListener(e,{'netAbortTrial','netTrialOutcome'});
    if abort
        break
    end

    % change position only every couple frames
    if mod(i-1,fpLoc)==0
        s(i) = round(rand(1) * len);
    else
        s(i) = s(i-1);
    end
    center(:,i) = startPos + s(i) * [cos(angle); -sin(angle)];
    
    % draw colored rectangle
    rect(:,i) = [center(:,i) - barSize/2; center(:,i) + barSize/2];
    Screen('DrawTexture',win,e.tex,[],rect(:,i),-angle*180/pi); 
    
    % buffer swap
    e = swap(e);
    
    % compute timeout
    if i == 1;
        startTime = getLastSwap(e);
        e = addEvent(e,'showStimulus',startTime);
    end

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
e = setTrialParam(e,'barLocations',s);
e = setTrialParam(e,'barRects',rect);
e = setTrialParam(e,'barCenters',center);

% return values
retInt32 = int32(0);
retStruct = struct;
returned = true;
