% Script to test FlePhysExperiment
% AE 2008-09-02

warning off TrialBasedExperiment:netStartTrial
warning off TrialBasedExperiment:netEndTrial
warning off StimulationData:setTrialParam
warning off StimulationData:setParam

T = FlePhysExperiment;
T = set(T,'debug',true);
T = openWindow(T);

constants.subject = 'DEBUG';
constants.eyeControl = 0;

constants.bgColor = [64; 64; 64];
constants.fixSpotColor = [255; 0; 0];
constants.fixSpotLocation = [0; 0];
constants.fixSpotSize = 10;

constants.barSize = [30; 300];
constants.barColor = [192; 192; 192];
constants.dx = 10;
constants.stimCenter = [960; 600];
constants.trajectoryAngle = 0;
constants.trajectoryLength = 500;
constants.numFlashLocs = 6;
constants.direction = [0 1];

constants.rewardProb = 1;
constants.joystickThreshold = 200;
constants.fixationRadius = 50;
constants.passive = 1;
constants.acquireFixation = 1;
constants.allowSaccades = 0;

constants.delayTime = 1500;
constants.postStimTime = 300;
constants.rewardAmount = 0;
constants.date = datestr(now,'YYYY-mm-dd_HH-MM-SS');

trials = struct;

T = netStartSession(T,constants);

for i = 1:12
    
    fprintf('trial #%d\n',i)

    T = netStartTrial(T,trials);
    T = netSync(T,struct('counter',0));
    T = netSync(T,struct('counter',1));
    T = netInitTrial(T);
    
    T = netShowFixspot(T,struct);
    pause(0.5)
    
    T = netShowStimulus(T,struct);
    
    T = netTrialOutcome(T,struct('correctResponse',true,'behaviorTimestamp',NaN));
    T = netEndTrial(T);

    pause(0.5)
end

T = netEndSession(T);
T = cleanUp(T);

