function [e,retInt32,retStruct,returned] = netStartTrial(e,params)
% Initialize trial.

% initilialize parent
[e,retInt32,retStruct,returned] = initTrial(e,params);

% compute post-stimulus fixation time
postStimTime = getParam(e,'postStimulusTime');
stimTime = getParam(e,'stimulusTime');
retStruct.delayTime = stimTime + postStimTime;
e = setTrialParam(e,'delayTime',retStruct.delayTime);

movieFile = getParam(e,'movieName');
moviePath = getParam(e,'moviePath');
movieNumber = getParam(e,'movieNumber');
movieStat = e.movieStat{getParam(e,'movieStat')};

% initialize movie
win = get(e,'win');
filename = getLocalPath(sprintf('%s%s%d_%s.mpg',moviePath, ...
                movieFile,movieNumber,movieStat));

disp(filename)
e = setTrialParam(e,'filename',filename);
            
tic 
[movie movieduration fps imgw imgh] = Screen('OpenMovie', win, filename);
toc

e.frameSize = [imgw imgh];
e.movie = movie;

fprintf('Movie: %s  : %f seconds duration, %f fps, w x h = %i x %i...\n', ...
              movieFile, movieduration, fps, imgw, imgh);
                    

