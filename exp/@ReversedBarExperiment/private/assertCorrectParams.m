function assertCorrectParams(e)
% Make sure the necessary parameters are passed.
% AE & PhB 2007-10-13

% the following parameters must be set
needed = {'barSize', ...              (width; height) pixels
          'barColor', ...
          'speed', ...                pixels/sec
          'trajectoryCenter', ...     (x,y) from top left corner; center of box
          'trajectoryLength', ...     pixels
          'trajectoryAngle', ...      degrees (to be implemented)
          'initMapTrials', ...        initial rf mapping (at beginning of experiment only)
          'exceptionTypes', ...       e.g. {'reverse','stop'}
          'exceptionLocations',...    relative position where reverals/stops occur   
          'exceptionRate', ...        percent trials that are exceptions (blocked)
          'mapTime', ...
          'mapFramesPerLoc', ...
          };
      
% make sure parameters are set
there = cat(1,fieldnames(e.params.constants), ...
              fieldnames(e.params.conditions), ...
              fieldnames(e.params.trials));
missing = ~ismember(needed,there);
if any(missing)
    error('ReversedBarExperiment:assertCorrectParams', ...
          'The following parameters must be set for ReversedBarExperiment:%s', ...
          sprintf('\n%s',needed{missing}));
end
