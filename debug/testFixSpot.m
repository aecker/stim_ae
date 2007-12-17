warning off TrialBasedExperiment:netStartTrial
warning off TrialBasedExperiment:netEndTrial
warning off StimulationData:setTrialParam
warning off StimulationData:setParam

T = TrialBasedExperiment(NoRandomization,StimulationData);
T = set(T,'debug',true);
T = openWindow(T);

constants.subject = 'DEBUG';

constants.bgColor = [64; 64; 64];
constants.fixSpotColor = [255; 0; 0];
constants.fixSpotLocation = [0; 0];
constants.fixSpotSize = 10;
constants.rewardProb = 1;

T = netStartSession(T,constants);
T = netAcquireFixation(T,struct);

WaitSecs(20);

T = cleanup(T);
