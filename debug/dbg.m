% Script to test TrialBasedExperiment
% AE 2007-10-08

T = TrialBasedExperiment(BlockRandomization,StimulationData);

% set minimum amount of parameters for TrialBasedExperiment
T = netSetParam(T,struct('name','subject','type',1,'value','DEBUG'));
T = netSetParam(T,struct('name','bgColor','type',1,'value',[127.5; 127.5; 127.5]));
T = netSetParam(T,struct('name','fixSpotColor','type',1,'value',[255; 0; 0]));
T = netSetParam(T,struct('name','rewardProb','type',1,'value',1));

% set some randomized parameters to test randomization
T = netSetParam(T,struct('name','contrast','type',2,'value',[10 100]));
T = netSetParam(T,struct('name','orientation','type',2,'value',0:45:135));
T = netSetParam(T,struct('name','text','type',2,'value',{{'Hello','Bye'}}));

T = netStartSession(T);

T = netEndSession(T);





