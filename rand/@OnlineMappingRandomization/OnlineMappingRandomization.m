function r = OnlineMappingRandomization(params)
% Mani
% June-04-2008
%
% Keep track of the total number of valid trials
r.nTrials = params.nTrials; 
r.nTrialsCompleted = 0;
r = class(r,'OnlineMappingRandomization');

