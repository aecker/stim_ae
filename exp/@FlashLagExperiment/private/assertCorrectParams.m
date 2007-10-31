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
          'flashOffset', ...          pixels from the average position of 
          ...                         the moving bar during the flash
          'flashDuration', ...        number of frames the flash lasts
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
