function r = ModifiedStaircase
% Modified staircase procedure.
%   In the classical staircase paradigm, the intensity of the stimulus is
%   a deterministic function of the observer's response. If the observer
%   responds correctly n times, the stimulus intensity is reduced, while
%   upon a single incorrect response it is increased. 
%
%   A major disadvantage of this procedure is that some observers learn
%   these contingencies and might adapt their strategy (e.g. when the task
%   becomes too difficult simply respond randomly a few times until it is
%   easy again). To avoid this problem, we use a modified procedure in
%   which we draw the stimulus for each trial from a distribution centered
%   around the current stimulus intensity. This introduces some level of
%   randomness into the difficulty of the task and makes it difficult for
%   the monkeys to realize what is going on.
%
% AE 2010-10-14 & Some comments by MS 2010-12-11

% amount of change upon correct/wrong responses. Note that the changes are
% given on log2 scale.
r.correct = []; % value given in log2 scale. If you want to decrease the 
% orientation by 2 deg, set this value to 1 (2 = 2^1)
r.wrong = [];

% current threshold
r.threshold = []; % 'r.levels' are placed around this value.

% stimulus levels
r.levels = []; % Each value in this vector is used eventually in this expression: 
% orientation = centerOri + (2 * class - 1) * 2.^(stepSize * level);

r.maxLevel = []; % When plugged into 2.^(stepSize * maxLevel), gives you the 
% largest relative orientation of the stimulus.


% distribution used to draw stimulus levels in each trial (has to return
% integer values)
r.distribution = [];

% pool size
r.poolSize = [];

% condition pools for the different stimulus levels (to balance the amount
% of occurences of left/right for each stimulus level)
r.pools = {};

% to keep track of the current condition
r.currentLevel = [];
r.currentCondition = [];

r = class(r,'ModifiedStaircase');
