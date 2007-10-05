function e = init(e)
% Initialize experiment.
% AE 2007-02-22

% Determine number of frames we expect during stimulus presentation. We
% need this to make sure the buffer in the PhotoDiodeTimer is large enough
% so it doesn't have to grow at runtime which might cause the program to
% miss a buffer swap.
params = get(e,'params');
stimTime = max(params.stimTime);
hz = Screen('FrameRate', get(e,'win'));
% +5 to make sure it really fits
nFrames = stimTime / hz + 5;        
e.photoDiodeTimer = PhotoDiodeTimer(nFrames);
