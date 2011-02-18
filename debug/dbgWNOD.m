% Script to test WNOriDiscExperiment
% AE 2010-10-14

warning off TrialBasedExperiment:netStartTrial
warning off TrialBasedExperiment:netEndTrial
warning off StimulationData:setTrialParam
warning off StimulationData:setParam

try

T = WNOriDiscExperiment;
T = set(T,'debug',true);
T = openWindow(T);

% PARAMETERS for config file
constants.fixSpotColor = [255; 0; 0];
constants.fixSpotLocation = [0; 0];
constants.fixSpotSize = 10;
constants.bgColor = [127.5; 127.5; 127.5];

constants.monitorSize = [41; 30];
constants.monitorDistance = 107;
constants.monitorCenter = [800; 600];

constants.stimulusLocation = [100; 200];
constants.diskSize = 150;

constants.signalBlockSize = 1;
constants.stimFrames = 1;
constants.orientations = 0:5:175;
constants.oriBlockSize = 2;
constants.phases = [0 45 90 135 180 225 270 315];
constants.signals = [45 135];
constants.randSeedNum = 10;
constants.fixedSeedNum = 10;

constants.stepCorrect = -0.1;
constants.stepWrong = 0.4;
constants.stepSize = 0.2;
constants.initialThreshold = 0;
constants.distribution = '@(x) round((rand(1)  - 0.5) * 3 + x)';
constants.poolSize = 10;
constants.maxLevel = 5;

constants.contrast = 1;
constants.spatialFreq = 3;
constants.color = [1 1 1]';


constants.stimulusTime = 1000;
constants.postStimulusTime = 100;

constants.delayTime = 2000;
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


T = netStartSession(T,constants);

for i = 1:20
    
    fprintf('trial #%d\n',i)

    T = netStartTrial(T,trials);
    T = netSync(T,struct('counter',0));
    T = netSync(T,struct('counter',1));
    T = netInitTrial(T);
    
    T = netShowFixSpot(T,struct);
    pause(0.1)
    
    T = netShowStimulus(T,struct);
    
    T = netTrialOutcome(T,struct('correctResponse',true,'behaviorTimestamp',NaN));
    T = netEndTrial(T);

    pause(0.2)
end

T = netEndSession(T);
T = cleanUp(T);

catch 
    sca
    rethrow(lasterror)
end
