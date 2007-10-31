% Script to test TrialBasedExperiment
% AE 2007-10-08

warning off TrialBasedExperiment:netStartTrial
warning off TrialBasedExperiment:netEndTrial

T = ReversedBarExperiment(0);
T = set(T,'debug',true);

% set minimum amount of parameters for TrialBasedExperiment
T = netSetParam(T,struct('name','subject','type',1,'value','DEBUG'));
T = netSetParam(T,struct('name','bgColor','type',1,'value',[64; 64; 64]));
T = netSetParam(T,struct('name','fixSpotColor','type',1,'value',[255; 0; 0]));
T = netSetParam(T,struct('name','rewardProb','type',1,'value',1));

% set some randomized parameters to test randomization
T = netSetParam(T,struct('name','barSize','type',1,'value',[30; 300]));
T = netSetParam(T,struct('name','barColor','type',1,'value',[192; 192; 192]));
T = netSetParam(T,struct('name','speed','type',1,'value',500));
T = netSetParam(T,struct('name','trajectoryCenter','type',1,'value',[600; 800]));
T = netSetParam(T,struct('name','trajectoryLength','type',1,'value',500));
T = netSetParam(T,struct('name','trajectoryAngle','type',1,'value',30));
T = netSetParam(T,struct('name','mapTime','type',1,'value',1000));
T = netSetParam(T,struct('name','mapFramesPerLoc','type',1,'value',3));
T = netSetParam(T,struct('name','initMapTrials','type',1,'value',0));
T = netSetParam(T,struct('name','exceptionTypes','type',2,'value',{{'reverse','stop'}}));
T = netSetParam(T,struct('name','exceptionRate','type',1,'value',0.5));
T = netSetParam(T,struct('name','exceptionLocations','type',2,'value',[.4 .5 .6]));





T = openWindow(T);
T = netStartSession(T);

retStruct = struct('canStop',false);
i = 0;
while ~retStruct.canStop
    i = i+1;
    fprintf('trial #%d\n',i)
    T = netStartTrial(T);
    T = netShowStimulus(T);
    [T,i32,retStruct] = netEndTrial(T);
    pause(0.5)
end

T = netEndSession(T);





