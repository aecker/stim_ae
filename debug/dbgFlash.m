% Script to test TrialBasedExperiment
% AE 2007-10-08

warning off TrialBasedExperiment:netStartTrial
warning off TrialBasedExperiment:netEndTrial
warning off StimulationData:setTrialParam

T = FlashLagExperiment;
T = set(T,'debug',true);
T = openWindow(T);

constants.subject = 'DEBUG';

constants.bgColor = [64; 64; 64];
constants.fixSpotColor = [255; 0; 0];
constants.fixSpotLocation = [0; 0];
constants.fixSpotSize = 10;

constants.barSize = [30; 300];
constants.barColor = [192; 192; 192];
constants.speed = 1000;

constants.trajectoryCenter = [800; 500];
constants.trajectoryLength = 1600;
constants.trajectoryAngle = 0;

constants.flashLocation = 800;
constants.randLocation = 1;
constants.flashOffset = 200;
constants.flashOffsets = [-180 -120 -60 -20 0 20 60 120 180];
constants.offsetThreshold = 100;
constants.flashDuration = 1;
constants.perceivedLag = 30;
constants.noFlashZone = 100;

constants.expMode = false;
constants.maxBlockSize = 2;

constants.lagProb = 0.5;
constants.moveProb = 0;

constants.rewardProb = 1;
constants.randReward = 1;
constants.rewardAmount = 200;
% constants. = ;

trials = struct;

T = netStartSession(T,constants);

for i = 1:200
    
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

