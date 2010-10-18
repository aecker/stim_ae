% Script to test TrialBasedExperiment
% AE 2007-10-08

warning off TrialBasedExperiment:netStartTrial
warning off TrialBasedExperiment:netEndTrial
warning off StimulationData:setTrialParam
warning off StimulationData:setParam

T = MouseMovieExperiment;
T = set(T,'debug',true);
T = openWindow(T);

constants.subject = 'DEBUG';

constants.bgColor = [1; 1; 1] * 127.5;
constants.fixSpotColor = [255; 0; 0];
constants.fixSpotLocation = [0; 0];
constants.fixSpotSize = 10;
constants.monitorSize = [41; 30];
constants.monitorDistance = [100];
constants.monitorCenter = [800; 600];

constants.location = [0; 0];
constants.clipStartTimes = [20 100];
constants.clipLength = 10;
constants.movieFile = 'video1.avi';
constants.moviePath = 'X:\mouseCam\FinalMovies\';
constants.magnification = -1;
constants.rewardProb = 1;

constants.stimulusTime = 10000;
constants.postStimulusTime = 100;

constants.subject = 'DEBUG';
constants.eyeControl = 0;
constants.rewardProb = 1;
constants.joystickThreshold = 200;
constants.fixationRadius = 50;
constants.passive = 1;
constants.acquireFixation = 1;
constants.allowSaccades = 0;
constants.rewardAmount = 0;
constants.date = datestr(now,'YYYY-mm-dd_HH-MM-SS');

trials = struct;

%params.constants = constants;
T = netStartSession(T,constants);

for i = 1
    
    fprintf('trial #%d\n',i)

    T = netStartTrial(T,trials);
    T = netSync(T,struct('counter',0));
    T = netSync(T,struct('counter',1));
    T = netInitTrial(T);
    
    T = netShowFixspot(T,struct);
    pause(0.5)
    
    tic
    T = netShowStimulus(T,struct);
    toc
    
    T = netTrialOutcome(T,struct('correctResponse',true,'behaviorTimestamp',NaN));
    T = netEndTrial(T);

    pause(0.5)
end

T = netEndSession(T);
T = cleanUp(T);

