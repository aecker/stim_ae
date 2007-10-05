function assertCorrectParams(e,params)
% Make sure the necessary parameters are passed.
% AE 2007-10-05

needed = {'bgColor','fixSpotColor','rewardProb'};
there = fieldnames(params);
missing = ~ismember(needed,there);
if any(missing)
    error('TrialBasedExperiment:asserCorrectParams', ...
          'The following parameters must be set for TrialBasedExperiment:%s', ...
          sprintf('\n%s',needed{missing}));
end
