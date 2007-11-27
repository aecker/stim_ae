% Script to test TrialBasedExperiment
% AE 2007-10-08

clear constants trials E
cla

warning off TrialBasedExperiment:netStartTrial
warning off TrialBasedExperiment:netEndTrial
warning off StimulationData:setTrialParam
warning off StimulationData:setParam

E = EyeCalibration;
E = set(E,'debug',true);
E = openWindow(E);

constants.subject = 'DEBUG';

constants.bgColor = [0; 0; 0];
constants.fixSpotColor = [255; 0; 0];

constants.rewardProb = 1;
constants.randReward = 1;
constants.rewardAmount = 200;
% constants. = ;

trials = struct;

E = netStartSession(E,constants);

for i = 1:10
    
    fprintf('trial #%d\n',i)
    
    % pick random numbers to see if it  works trial-by-trial
    trials.fixSpotLocation = rand(2,1) * 500;
    trials.fixSpotSize = rand(1) * 50;

    E = netStartTrial(E,trials);
    E = netSync(E,struct('counter',0));
    E = netSync(E,struct('counter',1));
    E = netInitTrial(E);
    
    E = netAcquireFixation(E,struct);
    pause(0.5)
    
    E = netShowStimulus(E,struct);
    
    E = netTrialOutcome(E,struct('correctResponse',true));
    E = netEndTrial(E);

    pause(0.5)
end

E = netEndSession(E);
E = cleanUp(E);

