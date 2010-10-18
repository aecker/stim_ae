function [e,retInt32,retStruct,returned] = netInitTrial(e,params)
% Trial initialization.
%   This function can be overridden to perform time-consuming initialization 
%   code during intertrial. Whether you override this function of netStartTrial
%   will affect the actual amount of time between two stimuli. Since all 
%   function calls from LabView (except netShowStimulus) are blocking by
%   default, any time spent in netStartTrial will add to the intertrial time,
%   since its counter starts after netStartTrial returns. In contrast,
%   netInitTrial is run during intertrial, meaning that time spent here won't
%   extend the intertrial time (provided the function doesn't take longer than
%   intertrialTime ms).
%
% AE 2009-03-16

tic

% make stimulus
win = get(e,'win');
% rect = Screen('Rect',win);
cond = getParam(e,'condition');

n = getSessionParam(e,'imageNumber',cond);          % number of the image
n = find(e.textureNum == n);
stat = e.imgStatConst{getSessionParam(e,'imageStats',cond)};

% read image
img = e.textureFile(n).(stat); %#ok<FNDSB>
e.curTexSz = size(img)';  

% generate texture
if ~isempty(e.curTex)
    Screen('Close',e.curTex);
end
e.curTex = Screen('MakeTexture',win,img');

disp(toc)

retInt32 = int32(0);
retStruct = struct;
returned = false;
