function r = AllImagesRandomization(imagePath,imageStats)
% Custom randomizaton to show each image once

r.imagePath = imagePath;
r.imageStats = imageStats;

r.imageList = [];

r.conditions = repmat(struct,0,0);

r.conditionPool = [];
r.conditionIdx = 1;

% Create class object
r = class(r,'AllImagesRandomization');
