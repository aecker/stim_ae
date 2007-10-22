function err = saveData(data)
% Write StimulationData to disk.
%   Files are named after the experiment class (i.e. in this case
%   TrialBasedExperiment) and numbered. So we check what is currently the
%   highest number and increase this by one.

try
    doSave(data,data.folder);
    err = 0;
catch
    doSave(data,data.fallback);
    err = 1;
    fprintf('------------------------------\n')
    fprintf('Saving on at-storage failed. Created local backup in %s',data.fallback);
    fprintf('------------------------------\n')
end


%% Subfunction actually doing the save operation
function doSave(data,where)
    warning off MATLAB:MKDIR:DirectoryExists
    mkdir(where)
    % convert to simple matlab structure and get rid of some fields
    stim = struct(data);
    stim = rmfield(stim,{'folder','fallback','defaultTrial'});
    save(sprintf('%s/%s.mat',where,data.params.constants.expType),'stim')
