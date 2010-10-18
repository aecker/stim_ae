function [e,retInt32,retStruct,returned] = netStartTrial(e,params)
% Initialize trial.

% initilialize parent
[e,retInt32,retStruct,returned] = initTrial(e,params);

% compute post-stimulus fixation time
postStimTime = getParam(e,'postStimulusTime');
stimTime = getParam(e,'stimulusTime');
retStruct.delayTime = stimTime + postStimTime;
e = setTrialParam(e,'delayTime',retStruct.delayTime);

movieFile = getParam(e,'movieFile');
moviePath = getParam(e,'moviePath');

% initialize movie
win = get(e,'win');
filename = getLocalPath([moviePath movieFile]);
tic 
[movie movieduration fps imgw imgh] = Screen('OpenMovie', win, filename);
toc

e.frameSize = [imgw imgh];
e.movie = movie;

fprintf('Movie: %s  : %f seconds duration, %f fps, w x h = %i x %i...\n', ...
              movieFile, movieduration, fps, imgw, imgh);
                    

