function assertCorrectParams(e)
% Make sure the necessary parameters are passed.
% AE & PhB 2007-10-08

% the following parameters must be set
needed = {'barSize', ...              (width; height) pixels
          'barColor', ...
          'speed', ...                pixels/sec
          'trajectoryCenter', ...     (x,y) from top left corner; center of box
          'trajectoryLength', ...     pixels
          'trajectoryAngle', ...      degrees (to be implemented)
          'initMapTrials', ...        initial rf mapping (at beginning of experiment only)
%           'mapLocPerTrial', ...       random locations per mapping trial
%           'mapFramesPerLoc', ...      frames per location
          'mapTrials', ...            mapping trials at end of each moving block
%           'reversalTrials', 10, ...          trials where movement reverses
%           'reversalLocation', 0.5, ...       % of total trajectory length where reversal occurs
          'movingTrials', ...         trials with normal movement
%           'blocksPerPrior', ...           
          'prior', ...                fraction of rightwards movement
          'mapTime', ...
          'mapFramesPerLoc', ...
          };
      
% make sure parameters are set
there = cat(1,fieldnames(e.params.constants), ...
              fieldnames(e.params.conditions), ...
              fieldnames(e.params.trials));
missing = ~ismember(needed,there);
if any(missing)
    error('MovingBarExperiment:assertCorrectParams', ...
          'The following parameters must be set for MovingBarExperiment:%s', ...
          sprintf('\n%s',needed{missing}));
end
