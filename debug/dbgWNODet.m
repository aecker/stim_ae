% Script to test WNOriDiscExperiment
% AE 2010-10-14

warning off TrialBasedExperiment:netStartTrial
warning off TrialBasedExperiment:netEndTrial
warning off StimulationData:setTrialParam
warning off StimulationData:setParam

try

T = WNOriDetectExperiment;
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
constants.phase = 0;
constants.orientations = 0 : 5 : 175;

constants.biases = [0 : 4; 4 : -1 : 0];
constants.signals = [45 135];
constants.coherences = [2 4 8 16 32];
constants.nSeeds = 10;
constants.nCatchPerBlock = 10;
constants.nRepsPerBlock = 5;
constants.subBlockSize = 10;

constants.nFramesPreMin = 50;
constants.nFramesPreMean = 150;
constants.nFramesPreMax = 350;
constants.nFramesCoh = 50;

constants.waitTime = 100;
constants.responseTime = 1000;

constants.contrast = 1;
constants.spatialFreq = 3;
constants.color = [1 1 1]';

constants.subject = 'DEBUG';
constants.eyeControl = 0;
constants.rewardProb = 1;
constants.joystickThreshold = 200;
constants.fixationRadius = 50;
constants.passive = 0;
constants.acquireFixation = 1;
constants.allowSaccades = 0;
constants.rewardAmount = 0;
constants.date = datestr(now,'YYYY-mm-dd_HH-MM-SS');

trials = struct;

nBlocks = size(constants.biases, 2);
blockSize = constants.nRepsPerBlock * numel(constants.coherences) * sum(constants.biases(:, 1)) + constants.nCatchPerBlock;
nCorrect = nBlocks * blockSize;
nTrials = round(1.1 * nCorrect);
r = randperm(nTrials);
v = false(1, nTrials);
v(r(1 : nCorrect)) = true;

T = netStartSession(T, constants);

for i = 1 : nTrials
    
    fprintf('trial #%d\n',i)

    T = netStartTrial(T, trials);
    T = netSync(T, struct('counter',0));
    T = netSync(T, struct('counter',1));
    T = netInitTrial(T);
    
    T = netShowFixSpot(T, struct);
    pause(0.1)
    
    T = netShowStimulus(T, struct);
    
    T = netTrialOutcome(T, struct('correctResponse', v(i), 'behaviorTimestamp', NaN));
    T = netEndTrial(T);

    pause(0.5)
end

T = netEndSession(T);
T = cleanUp(T);

catch 
    sca
    rethrow(lasterror)
end
