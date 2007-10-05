function saveData(data,expType,subject,date,varargin)
% Write StimulationData to disk.
%   Files are named after the experiment class (i.e. in this case
%   TrialBasedExperiment) and numbered. So we check what is currently the
%   highest number and increse this by one.

% convert to simple matlab structure and get rid of some fields
stim = struct(data);
stim = rmfield(stim,'nEvents');
stim = rmfield(stim,'curTrial');
stim = rmfield(stim,'defaultTrial');
stim = rmfield(stim,'eventSites');
stim.expType = expType;
stim.subject = subject;
stim.date = date;

% reorder fields
stim = orderfields(stim,{'expType','subject','date','eventNames','trials'});

% put additional fields
for i = 1:2:length(varargin)
    stim.(varargin{i}) = varargin{i+1};
end

% save it...
% Here we should change the location where the data is written to...
warning('off','MATLAB:MKDIR:DirectoryExists')
folder = sprintf('/Volumes/lab/data/%s/%s',stim.subject,stim.date);
mkdir(folder)
d = dir(sprintf('%s/%s*.mat',folder,expType));
m = 0;
for i = 1:length(d)
    m = max(m,sscanf(d(i).name,sprintf('%s%%2d.mat',expType)));
end
save(sprintf('%s/%s%.2d.mat',folder,expType,m+1),'stim');
