% Script to test TrialBasedExperiment
% AE 2007-10-08

warning off TrialBasedExperiment:netStartTrial
warning off TrialBasedExperiment:netEndTrial
warning off StimulationData:setTrialParam
warning off StimulationData:setParam

T = DotMappingExperiment;
T = set(T,'debug',true);
T = openWindow(T);

constants.subject = 'DEBUG';

constants.bgColor = [127.5; 127.5; 127.5];
constants.fixSpotColor = [255; 0; 0];
constants.fixSpotLocation = [0; 0];
constants.fixSpotSize = 10;
constants.delayTime = 1000;
constants.randReward = true;

constants.monitorSize = [41; 30];
constants.monitorDistance = 107;
constants.monitorCenter = [800; 600];

constants.delayTime = 800;
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

constants.dotColor = [0 255];


trials.dotSize = 120;
trials.dotNumX = 14;
trials.dotNumY = 8;
trials.stimFrames = 15;
trials.stimCenterX = 800;
trials.stimCenterY = 600;
trials.pFill = 1;

T = netStartSession(T,constants);

try
    for i = 1:2

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

catch
    sca
    err = lasterror;
    error(err)
end

