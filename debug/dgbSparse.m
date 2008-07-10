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

constants.location = [250; 250];
constants.diskSize = 200;
constants.fadeFactor = 1.3;

constants.imagePath = '\\steinlach\berens\projects\sparsecoding\stimuli\stimuli';
constants.imageNumber = [152];
constants.imageStats = {'whn','nat','phs'};
constants.modFunction = {'0.5*(sin(2*pi*3*(t*fd/1000))+1)', ...
                         '(mod(t*fd,300)>200)*0+(mod(t*fd,300)<=200)*1', ...
                         '1'};

constants.rewardProb = 1;

constants.delayTime = 1000;
constants.postStimTime = 250;
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
    
    T = netAcquireFixation(T,struct);
    pause(0.5)
    
    T = netShowStimulus(T,struct);
    
    T = netTrialOutcome(T,struct('correctResponse',true));
    T = netEndTrial(T);

    pause(0.5)
end

T = netEndSession(T);
T = cleanUp(T);

