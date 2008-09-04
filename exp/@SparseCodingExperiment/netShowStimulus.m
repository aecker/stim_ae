function [e,retInt32,retStruct,returned] = netShowStimulus(e,params)

% important re: modulation function:
% this is a string defined in the parameter file that depends on the frame
% number t and may depend on the frame refresh rate 'fd'. it generally
% should return values between 0 and 1
% examples:
%   stimulus on for the whole time f(t,fd)=1
%   stimulus modulated with a 5 Hz sinusoid
%                       '0.5*(sin(2*pi*5*(t*fd/1000))+1)'
%   stimulus on for 100 ms and off for 50 ms
%                       '(mod(t*fd,150)>100)*0+(mod(t*fd,150)<=100)*1'

% some member variables
win = get(e,'win');
rect = Screen('Rect',win);
refresh = get(e,'refreshRate');

% read parameters
curIdx = getParam(e,'condition');
location = getParam(e,'location');
stimTime = getParam(e,'stimulusTime');
postStimTime = getParam(e,'postStimulusTime');
fadeFactor = getParam(e,'fadeFactor');
modFunction = getParam(e,'modFunction');
f = inline(modFunction,'t');
%f = inline('rem(t,.25)<.2','t');

n = getParam(e,'imageNumber');
imStats = e.imgStatConst{getParam(e,'imageStats')};

fprintf('\n image id: %05.0f, image stats: %s',n,imStats);

% some shortcuts
texture = e.textures(curIdx);
texSize = fadeFactor*getParam(e,'diskSize');
alpha = e.alphaMask(curIdx);
centerX = mean(rect([1 3])) + location(1);
centerY = mean(rect([2 4])) + location(2);


% return function call
tcpReturnFunctionCall(e,int32(0),struct,'netShowStimulus');

firstTrial = true;
running = true;
t = 1;  % frame counter
modul = zeros(1);
while running

    % check for abort signal
    [e,abort] = tcpMiniListener(e,{'netAbortTrial','netTrialOutcome'});
    if abort
        fprintf('stimulus was aborted.....................................\n')
        break
    end
    
    destRect = [-texSize -texSize texSize texSize] / 2 ...
                    + [centerX centerY centerX centerY];
    
    % draw texture, aperture, flip screen
    if firstTrial
        modul(t) = true;
    else
        modul(t) = f(getLastSwap(e)-startTime);
    end
%    Screen('DrawTexture',win,texture,[],destRect,0,[],f(t,1000/refresh)); 
    Screen('DrawTexture',win,texture,[],destRect,0,[],modul(t)); 
    Screen('DrawTexture',win,alpha); 
    drawFixspot(e);
    e = swap(e);
    t = t + 1;      % count new frame
    
    % compute startTime
    if firstTrial
        startTime = getLastSwap(e);
        e = addEvent(e,'showStimulus',startTime);
        firstTrial = false;
    end
    
    % compute timeOut
    running = (getLastSwap(e)-startTime)*1000 < stimTime;
end

e = setTrialParam(e,'modul',modul);


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

% return values
retInt32 = int32(0);
retStruct = struct;
returned = true;

