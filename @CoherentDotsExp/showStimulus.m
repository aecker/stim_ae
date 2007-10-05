function e = showStimulus(e)
% Show Coherent Dots

% some member variables..
win = get(e,'win');
con = get(e,'con');
curParams = get(e,'curParams');
curIndex = get(e,'curIndex');
params = get(e,'params');

rect = Screen('Rect',win);
black = BlackIndex(win);
white = WhiteIndex(win);

Screen('BlendFunction', win, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
[center(1), center(2)] = RectCenter(rect);
fps=Screen('FrameRate',win);      % frames per second
ifi=Screen('GetFlipInterval',win);
if fps==0
   fps=1/ifi;
end;

HideCursor;	% Hide the mouse cursor
Priority(MaxPriority(win));


    % ------------------------
    % set dot field parameters
    % ------------------------

    nframes     = 1000; % number of animation frames in loop
    mon_width   = 39;   % horizontal dimension of viewable screen (cm)
    v_dist      = 60;   % viewing distance (cm)
    dot_speed   = curParams.speed;    % dot speed (deg/sec)
    ndots       = curParams.numDots; % number of dots
    max_d       = curParams.annulus;   % maximum radius of  annulus (degrees)
    dot_w       = curParams.dotSize;  % width of dot (deg)
    f_kill      = curParams.fkill; % fraction of dots to kill each frame (limited lifetime)    
    differentcolors =0; % Use a different color for each point if == 1. Use common color white if == 0.
    differentsizes = 0; % Use different sizes for each point if >= 1. Use one common size if == 0.
    waitframes = 1;     % Show new dot-images at each waitframes'th monitor refresh.
    
    coherence = curParams.coherence;     % Percent coherence in preferred direction
    pdir = curParams.direction;           % Preferred direction
    
    if differentsizes>0  % drawing large dots is a bit slower
        ndots=round(ndots/5);
    end
    
    ndotsr = ceil((1-coherence/100) * ndots)   % number of dots with random direction
    ndotsf = floor(coherence/100 * ndots)         % number of dots with fixed direction

    % ---------------------------------------
    % initialize dot positions and velocities
    % ---------------------------------------

    ppd = pi * (rect(3)-rect(1)) / atan(mon_width/v_dist/2) / 360;    % pixels per degree
    pfs = dot_speed * ppd / fps;                            % dot speed (pixels/frame)
    s = dot_w * ppd;                                        % dot size (pixels)

    rmax = max_d * ppd;	% maximum radius of annulus (pixels from center)
    r = rmax * sqrt(rand(ndots,1));	% r
    
    t = [2*pi*rand(ndotsr,1); 2*pi*pdir/360*ones(ndotsf,1)]; % theta polar coordinate
    cs = [cos(t), sin(t)];
    
    ts = [2*pi*rand(ndots,1)];  % orientation for start
    css = [cos(ts), sin(ts)];  
    xy = [r r] .* css;   % dot positions in Cartesian coordinates (pixels from center)

    dr = pfs * ones(ndots,1);                            % change in radius per frame (pixels)
    dxdy = [dr dr] .* cs;                       % change in x and y per frame (pixels)

    % Create a vector with different colors for each single dot, if
    % requested:
    if (differentcolors==1)
        colvect = uint8(round(rand(3,ndots)*255));
    else
        colvect=white;
    end;
    
    % Create a vector with different point sizes for each single dot, if
    % requested:
    if (differentsizes>0)
        s=(1+rand(1, ndots)*(differentsizes-1))*s;        
    end;    

    % ---------------
    % open the screen
    % ---------------

    
    % Do initial flip...
    vbl=Screen('Flip', win);
    
    % --------------
    % animation loop
    % --------------    
    
    % control loop: we remove the stimulus after params.stimTime seconds or a
    % tcp abort command, whichever comes first.
    endTime = inf;
    i = 0;
    T = zeros(curParams.stimTime/10,1);

    while GetSecs < endTime

        t1 = GetSecs;

        % Check for abort signal
        fctName = pnet(con,'readline',2^16,'view','noblock');
        if ~isempty(fctName)
            % clear read buffer and abort
            pnet(con,'readline');
            e = feval(fctName,e);
            return;
        end

        if (i>1)            
            drawFixSpot(e); % draw fixspot
            Screen('DrawDots', win, xymatrix, s, colvect, center,1);  % change 1 to 0 to draw square dots
            Screen('DrawingFinished', win); % Tell PTB that no further drawing commands will follow before Screen('Flip')
        end;
        
        xy = xy + dxdy;						% move dots
        r = (xy(:,1).^2 + xy(:,2).^2).^(1/2);							% update polar coordinates too

        % check to see which dots have gone beyond the borders of the annuli

        r_out = find(r > rmax | rand(ndots,1) < f_kill);	% dots to reposition
        nout = length(r_out);

        if nout

            % choose new coordinates
            ts = [2*pi*rand(nout,1)];  % orientation for start
            css = [cos(ts), sin(ts)];  
            xy(r_out,[1 2]) = [rmax*ones(nout,2)] .* css;   % dot positions in Cartesian coordinates (pixels from center)

        end;
        xymatrix = transpose(xy);
        
        T(i+1) = (GetSecs - t1) * 1000;

        % flip buffers
        vblTime = Screen('Flip',win);
    
        % first iteration. store start time and compute end time
        if i == 0
            e = addEvent(e,'showStimulus',vblTime);
            endTime = vblTime + curParams.stimTime/1000;
        end
        i = i+1;

        %pause(0.001);
        %pause;
    end;
    Priority(0);


% send 'completed' to state system
pnet(con,'write',uint8(1));

% clear screen
e = clearScreen(e);

