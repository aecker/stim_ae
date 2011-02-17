function r = init(r,params)
% AE 2010-10-14

% initialize BlockRandomization to deal with signal orientations and
% probability of occurence
bp.signal = params.signal;
bp.signalProb = params.signalProb;
r.signalBlock = init(BlockRandomization('signal','signalProb'),bp);

% use white noise randomization to increase block size
scond = getConditions(r.signalBlock);
ns = numel(scond);
r.signalWhite = init(WhiteNoiseRandomization,repmat(1:ns,1,params.signalBlockSize));

% create noise conditions
np.orientation = params.orientation;
np.phase = params.phase;
r.noiseBlock = init(BlockRandomization('orientation','phase'),np);

% create WhiteNoiseRandomizations to deal with noise for reverse
% correlation
no = numel(params.orientation);
ncond = getConditions(r.noiseBlock);
nn = numel(ncond);
for i = 1:ns
    p = scond(i).signalProb;
    m = round(p / (1 - p) * (no - 1));
    s = find([ncond.orientation] == scond(i).signal);
    s = reshape(repmat(s,m-1,1),1,[]);
    r.noiseWhite{i} = init(WhiteNoiseRandomization,[1:nn s]);
end
