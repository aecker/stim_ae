function e = loadImageTexture(e)
%Load image textures:
% this function loads the images from disk into a two dimensional 
% cell array, where each cell contains an array with an image
unix('pwd')
params = get(e,'params');
for(i = 1:length(params.imageClass))
	for(j = 1:length(params.imageNum))
       
		e.images{i,j} = imread(sprintf('@JoystickTraining/images/%s%d.jpg',params.imageClass{i},params.imageNum(j))); 
	end
end