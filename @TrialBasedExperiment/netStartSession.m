function [e,retInt32,retStruct,returned] = netStartSession(e,params)
% Start TrialBasedExperiment session.
% Here we initialize the StimulationData object etc.
%
% AE 2007-10-01

e = init(e);

retInt32 = int32(0);
retStruct = struct;
returned = false;
