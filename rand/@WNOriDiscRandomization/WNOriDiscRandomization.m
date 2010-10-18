function r = WNOriDiscRandomization
% Randomization for white noise orientation discrimination
% AE 2010-10-14

% block randomization to manage signal conditions
r.signalBlock = [];

% white noise randomization to increase block sizes
r.signalWhite = [];

% block randomization to manage noise conditions
r.noiseBlock = [];

% white noise randomization to manage noise orientations within each signal
% condition
r.noiseWhite = {};

% to keep track of which white noise randomization is the current one
r.currentCond = [];

r = class(r,'WNOriDiscRandomization');
