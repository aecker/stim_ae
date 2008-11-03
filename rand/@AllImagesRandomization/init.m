function r = init(r,params)
% Initialize randomization.
% AE & PhB 2007-10-09

% get all avaible images
fileList = dir(getLocalPath(r.imagePath));
valIdx = arrayfun(@(x)(~isempty(strfind(x.name,'.tif'))),fileList) & ...
            ~[fileList.isdir]';
fileList = fileList(valIdx);

% delete those with the wrong stats
statIdx = zeros(size(fileList,1),length(r.imageStats));
for i=1:length(r.imageStats)
    statIdx(:,i) = arrayfun(@(x)(~isempty(strfind(x.name,r.imageStats{i}))), ...
        fileList);
end
statIdx = any(statIdx,2);
fileList = fileList(statIdx);

% save image list
r.imageList = fileList;

% compute list of images
r = computeConditions(r);

