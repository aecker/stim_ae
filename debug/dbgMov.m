% Script to test TrialBasedExperiment
% AE 2007-10-08

warning off TrialBasedExperiment:netStartTrial
warning off TrialBasedExperiment:netEndTrial
warning off StimulationData:setTrialParam
warning off StimulationData:setParam

T = MovingBarExperiment;
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


constants.rewardProb = 1;
constants.randReward = 1;
constants.rewardAmount = 200;

constants.numSubBlocks = 3;
constants.movingTrials = 10;
constants.mapTrials = 3;
constants.initMapTrials = 5;

constants.prior=[0.5 0.9];
constants.mapTime = 1000;
constants.mapFramesPerLoc = 3;

trials = struct;

%params.constants = constants;
T = netStartSession(T,constants);

for i = 1:10
    
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

