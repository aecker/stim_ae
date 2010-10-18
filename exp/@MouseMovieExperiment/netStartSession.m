function [e,retInt32,retStruct,returned] = netStartSession(e,params)

% initialize parent
[e,retInt32,retStruct,returned] = initSession(e,params);

e = set(e,'photoDiodeTimer',PhotoDiodeTimer(params.stimulusTime/1000*60,[0 255],50));

% movieFile = params.movieFile;
% moviePath = params.moviePath;
% 
% % initialize movie
% win = get(e,'win');
% filename = getLocalPath([moviePath movieFile]);
% [movie movieduration fps imgw imgh] = Screen('OpenMovie', win, filename);
%         
% fprintf('Movie: %s  : %f seconds duration, %f fps, w x h = %i x %i...\n', ...
%               movieFile, movieduration, fps, imgw, imgh);
% 
% e.movie = movie;
% e.frameSize(1) = imgw;
% e.frameSize(2) = imgh;
% e.frameRate = fps;
% e.movieLength = movieduration;
% 
% 
% 
