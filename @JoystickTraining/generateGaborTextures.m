function e = generateGaborTexture(e)
%GenerateGaborTexture Generates gabor patch texture for openGL.

win = get(e,'win');
params = get(e,'params');
wg = params.diskSize;
halfWidthOfGrid = wg/2;
widthArray = (-halfWidthOfGrid) : halfWidthOfGrid;

%generate texture for gabor patch
nContrast = length(params.contrast);
nSpatFreq = length(params.spatialFreq);
gaussianSpaceConstant = ...
    params.pcb1sd./params.spatialFreq;

black = BlackIndex(win);  % Retrieves the CLUT color code for black.
white = WhiteIndex(win);  % Retrieves the CLUT color code for white.
gray = (black + white) / 2
absoluteDifferenceBetweenWhiteAndGray = abs(white - gray);

numFrames = 360;
params
if(length(params.pcb1sd) == 0)
    error('pcb1sd not set');
end
if(length(params.pcbsize) == 0)
    error('pcbsize not set');
end

try
    AssertOpenGL
    for i = 1:nContrast
        for j = 1:nSpatFreq
            gaussianSpaceConstant = ...
                params.pcb1sd/params.spatialFreq(j);
            [x y] = meshgrid(widthArray, widthArray);
            for k = 1:numFrames
                phase = 2*pi*(k/numFrames);
                gratingMatrix = sin(params.spatialFreq(j) .* y+phase);
                circularGaussianMaskMatrix = exp(-((x .^ 2) + (y .^ 2)) / (gaussianSpaceConstant ^ 2));
                circularGaussianMaskMatrix2 = exp(-((x .^2) + (y .^ 2)) / (params.pcbsize ^ 2));
                imageMatrix = gratingMatrix .* circularGaussianMaskMatrix .* circularGaussianMaskMatrix2;
                grayscaleImageMatrix = gray+(params.contrast(i)/100 * absoluteDifferenceBetweenWhiteAndGray * imageMatrix);
                e.textures(i,j,k) = Screen('MakeTexture',win,grayscaleImageMatrix);
            end
        end
    end
catch
    sca
    pnet closeall
    psychrethrow(psychlasterror);
end
