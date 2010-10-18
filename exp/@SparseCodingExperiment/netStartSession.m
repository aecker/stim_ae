function [e,retInt32,retStruct,returned] = netStartSession(e,params)

idx = params.imageNumber;
file = params.imageFile;
file = load(getLocalPath(file));
textures = file.textures(idx);

e.textureFile = textures;
e.textureNum = idx;

% initialize parent
[e,retInt32,retStruct,returned] = initSession(e,params);

% Enable alpha blending with proper blend-function. We need it
% for drawing of our alpha-mask (gaussian aperture)
win = get(e,'win');
Screen('BlendFunction',win,GL_SRC_ALPHA,GL_ONE_MINUS_SRC_ALPHA);
