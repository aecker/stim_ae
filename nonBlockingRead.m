function nonBlockingRead(port)

% network port
if nargin < 1, port = 1234; end

% parameters
duration = 2000;    % ms
diskSize = 800;     % pixels
pxPerSec = 50;      % velocity
radPerPx = 0.1;     % spatial frequency
orientation = pi/4; % radians

% wait for client connecting
socket = pnet('tcpsocket',port);
con = pnet(socket,'tcplisten');
[ip,port] = pnet(con,'gethost');
fprintf('\nClient %d.%d.%d.%d connected on port %d.\n\n',ip,port)

% open stimulus window
Screen('Preference','VisualDebugLevel',3);
Screen('Preference','SuppressAllWarnings',1);
[win,rect] = Screen('OpenWindow',max(Screen('Screens')));
x = (rect(1) + rect(3)) / 2;
y = (rect(2) + rect(4)) / 2;

% Enable alpha blending with proper blend-function. We need it
% for drawing of our alpha-mask (gaussian aperture):
Screen('BlendFunction',win,GL_SRC_ALPHA,GL_ONE_MINUS_SRC_ALPHA);

% generate grating texture
period = 2*pi / radPerPx;
extDiskSize = ceil(diskSize + period);
black = BlackIndex(win);
white = WhiteIndex(win);
gray = (black + white) / 2;
mag = abs(white - gray);
[X,Y] = meshgrid(1:extDiskSize, 1:extDiskSize);
gratingMatrix = gray + mag * sin(radPerPx .* Y);
texture = Screen('MakeTexture',win,gratingMatrix);

% generate aperture
[X,Y] = meshgrid((1:rect(3))-x, (1:rect(4))-y);
alphaLum = repmat(gray,rect(4),rect(3));
alphaBlend = 255 * (sqrt(X.^2 + Y.^2) > diskSize/2);
alpha = Screen('MakeTexture',win,cat(3,alphaLum,alphaBlend));

% make gray background and add fixspot
Screen('FillRect',win,gray);
Screen('Flip',win);

% keep looping while client connected
while pnet(con,'status')

%     % add fixspot
%     Screen('glPoint',win,[255 0 0],x,y,10);
%     startTime = Screen('Flip',win);
%     endTime = startTime + duration/1000;
    
    % save starting time (this is not yet accurate at all...)
    startTime = GetSecs;
    endTime = startTime + duration/1000;

    % control loop: we remove the stimulus after <duration> seconds or a
    % tcp abort command, whichever comes first.
    data = [];
    i = 0;
    while GetSecs < endTime
        
        % check for abort signal
        data = pnet(con,'readline',2^16,'view','noblock');
        if ~isempty(data) || ~pnet(con,'status')
            elapsedTime = (GetSecs - startTime) * 1000;
            pnet(con,'readline');
            break;
        end
        
        % update grating
        u = mod(i,period) - period/2;
        xInc = u * cos(orientation);
        yInc = u * sin(orientation);
        destRect = [-extDiskSize -extDiskSize extDiskSize extDiskSize] / 2 ...
            + [x y x y] + [xInc yInc xInc yInc];
        Screen('DrawTexture',win,texture,[],destRect,-orientation/pi*180); 
        Screen('DrawTexture',win,alpha); 
        Screen('Flip',win);
        
        i = i+1;
    end
    
    % print out what happened
    if isempty(data)
        fprintf('%6.1f ms elapsed (%d iterations)\n',duration,i);
    else
        fprintf('aborted after %6.1f ms (%d iterations)\n',elapsedTime,i);
    end

    % clear screen
    Screen('FillRect',win,gray);
    Screen('Flip',win);
    WaitSecs(1.5);

end
    
% close socket
pnet(socket,'close');

% close window
Screen('closeAll')
