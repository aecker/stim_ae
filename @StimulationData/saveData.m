function err = saveData(data)
% Write StimulationData to disk.
%   Files are named after the experiment class (i.e. in this case
%   TrialBasedExperiment) and numbered. So we check what is currently the
%   highest number and increase this by one.

try
    doSave(data.folder,data);
    err = 0;
catch
    doSave(data.fallback,data);
    err = 1;
    fprintf('------------------------------')
    fprintf('Saving on at-storage failed. Created local backup in %s',data.fallback);
    fprintf('------------------------------')
end


%% Subfunction actually doing the save operation
function doSave(data,where)
    warning off MATLAB:MKDIR:DirectoryExists
    mkdir(where)
    % convert to simple matlab structure and get rid of some fields
    stim = struct(data);
    stim = rmfield(stim,{'folder','fallback','defaultTrial','initialized'});
    save(sprintf('%s/%s.mat',where,data.constants.expType),'stim')
