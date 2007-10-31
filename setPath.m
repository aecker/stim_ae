function setPath

path = mfilename('fullpath');
folder = fileparts(path);
addpath(fullfile(folder,'exp'))
addpath(fullfile(folder,'debug'))
addpath(fullfile(folder,'rand'))
