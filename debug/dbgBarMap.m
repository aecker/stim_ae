% Script to test TrialBasedExperiment
% AE 2007-10-08

warning off TrialBasedExperiment:netStartTrial
warning off TrialBasedExperiment:netEndTrial
warning off StimulationData:setTrialParam
warning off StimulationData:setParam

T = BarMappingExperiment;
T = set(T,'debug',true);
T = openWindow(T);

constants.subject = 'DEBUG';

constants.bgColor = [127.5; 127.5; 127.5];
constants.fixSpotColor = [255; 0; 0];
constants.fixSpotLocation = [0; 0];
constants.fixSpotSize = 10;
constants.delayTime = 1000;

constants.barAngle = [0 45 90 135];
constants.allBarColors = [0 255];

constants.rewardProb = 1;
constants.randReward = 1;
constants.rewardAmount = 200;
constants.fixationMode = 0;

trials.barLength = 200;
trials.barWidth = 8;
trials.stimFrames = 5;
trials.stimCenter = [900; 700];

T = netStartSession(T,constants);

for i = 1:20
    
    fprintf('trial #%d\n',i)

    T = netStartTrial(T,trials);
    T = netSync(T,struct('counter',0));
    T = netSync(T,struct('counter',1));
    T = netInitTrial(T);
    
    T = netAcquireFixation(T,struct);
    pause(0.5)
    
    T = netShowStimulus(T,struct);
    
    T = netTrialOutcome(T,struct('correctResponse',true));
    T = netEndTrial(T);

    pause(0.5)
end

T = netEndSession(T);
T = cleanUp(T);

