function e = initSounds(e)
% Load sound files into data structure.
%
% AE 2007-02-21

basePath = fileparts(mfilename('fullpath'));

f = fieldnames(e.soundFiles);
for i = 1:length(f)
    e.soundWaves.(f{i}) = wavread(fullfile(basePath,'sounds', ...
        [e.soundFiles.(f{i}),'.wav']));
end
