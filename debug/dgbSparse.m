% Script to test TrialBasedExperiment
% AE 2007-10-08

warning off TrialBasedExperiment:netStartTrial
warning off TrialBasedExperiment:netEndTrial
warning off StimulationData:setTrialParam
warning off StimulationData:setParam

T = SparseCodingExperiment;
T = set(T,'debug',true);
T = openWindow(T);

constants.subject = 'DEBUG';
constants.eyeControl = 0;

constants.bgColor = [64; 64; 64];
constants.fixSpotColor = [255; 0; 0];
constants.fixSpotLocation = [0; 0];
constants.fixSpotSize = 10;

constants.location = [-10; 40];
constants.diskSize = 200;
constants.fadeFactor = 1.4;

constants.imageFile = '/kyb/agbs/aecker/lab/tmp/textures_400.mat';
constants.imageNumber = 1:5;
constants.imageStats = [1,2,3];
constants.modFunction = '1';

constants.monitorSize = [41; 30];
constants.monitorDistance = 109;
constants.monitorCenter = [920; 600];

constants.rewardProb = 1;
constants.joystickThreshold = 100;
constants.fixationRadius = 50;
constants.passive = 1;
constants.acquireFixation = 1;
constants.allowSaccades = 0;

constants.stimulusTime = 1000;
constants.delayTime = 1250;
constants.postStimulusTime = 250;
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
    pause(0.5)
    
    T = netShowStimulus(T,struct);
    
    T = netTrialOutcome(T,struct('correctResponse',true,'behaviorTimestamp',NaN));
    T = netEndTrial(T);

    pause(0.5)
end

T = netEndSession(T);
T = cleanUp(T);

