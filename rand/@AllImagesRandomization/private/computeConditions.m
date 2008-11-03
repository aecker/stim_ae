function r = computeConditions(r)
% Compute condition pool.
% AE 2007-10-05

nI = length(r.imageList);
r.conditionPool = randperm(nI);

r.conditions = struct('imageStat',[],'imageNumber',[]);
for i=1:nI
    imStat = r.imageList(i).name(end-6:end-4);
    imNum = r.imageList(i).name(1:5);
    r.conditions(i) = struct('imageStat',imStat, ...
                             'imageNumber',str2num(imNum));
end
    


