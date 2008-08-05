function fixEndTimeBug(folder,varargin)
% Fix bug that took stim.params.constants.endTime from the wrong clock.
% AE 2008-01-07

params.expNames = {'EyeCalibration','OnlineMappingExperiment', ...
                   'TrialBasedExperiment','FlashLagExperiment', ...
                   'MovingBarExperiment','ReversedBarExperiment', ...
                   'StoppedBarExperiment','GratingExperiment'};
params.mismatchTolerance = 120; % 2 mins
params = parseVarArgs(params,varargin{:});

folder = getLocalPath(folder);
d = dir(fullfile(folder,'*-*-*_*-*-*'));
for i = 1:length(d)
    sub = dir(fullfile(folder,d(i).name,'*.mat'));
    for j = 1:length(sub)
        % make sure we only load experiment files
        if ~isempty(strmatch(sub(j).name(1:end-4),params.expNames,'exact'))
            stimFile = fullfile(folder,d(i).name,sub(j).name);
            tmp = load(stimFile);
            stim = tmp.stim;
            fixed = false;

            % get rid of typo bug if there
            if isfield(stim.params.constants,'entTime')
                stim.params.constants = rmfield(stim.params.constants,'entTime');
                fixed = true;
            end
            
            % put endTime field if not there
            if ~isfield(stim.params.constants,'endTime')
                stim.params.constants.endTime = [];
                fixed = true;
            end
            
            if ~isempty(stim.events)
                % check startTime
                macSites = find(~stim.eventSites(stim.events(1).types));            
                firstEvent = stim.events(1).times(macSites(1));
                if abs(stim.params.constants.startTime - firstEvent) > ...
                        params.mismatchTolerance
                    stim.params.constants.startTime = firstEvent - 10;
                    fixed = true;
                end
                
                % check endTime
                macSites = find(~stim.eventSites(stim.events(end).types));            
                lastEvent = stim.events(end).times(macSites(end));
                if isempty(stim.params.constants.endTime) || ...
                        abs(stim.params.constants.endTime - lastEvent) > ...
                            params.mismatchTolerance
                    stim.params.constants.endTime = lastEvent + 10;
                    fixed  = true;
                end
            end

            % did we fix anything? => SAVE
            if fixed
                fprintf('Fixed %s\n',stimFile)
                save(stimFile,'stim')
            else
                fprintf('Skipped %s\n',stimFile)
            end
        end
    end
end
