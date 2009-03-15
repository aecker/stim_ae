function e = RodentMultDimExperiment(varargin)
% Multidimensional coding experiment for rodents.
%   Simply inherits the monkey version and overrides some of functions not used.
%
% AE 2009-03-15

e = class(struct,'RodentMultDimExperiment',MultDimExperiment);

% Prepare experiment
if nargin > 0 && startNow
    e = openWindow(e);
    e = tcpMainListener(e);
end
