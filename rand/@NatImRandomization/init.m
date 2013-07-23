function r = init(r, params)
% Initialize randomization

idx = zeros(3, params.seqGroupsPerSession, params.imPerTrial);
imNum = idx;
for iSeq = 1 : params.seqGroupsPerSession
    k = 0;
    for iIm = 1 : params.imPerTrial
        if k == 0
            idx(:, iSeq, iIm) = randperm(3);
        elseif k == 1
            %t = setdiff(r, idx(1,iSeq, iIm - 1));
            t = setdiff(1 : 3, idx(1,iSeq, iIm - 1)); %exchanged 2nd and 3rd dimension also what does the 'r' do there? Lg 07/18/13
            
            %r = randperm(2);
            rr = randperm(2); %call it rr since r is the randomization object also changed in the following LG 07/18/13
            idx(1, iSeq, iIm) = t(rr(1));
            
            %idx(2, iSeq, iIm) = setdiff(1 : 3, [idx(2, iSeq, iIm - 1) t(rr(1))]);
            if t(rr(1)) == idx(2, iSeq, iIm - 1)
                idx(2, iSeq, iIm) = setdiff(1 : 3, [idx(1 : 2, iSeq, iIm - 1)' t(rr(1))]);
            else
                idx(2, iSeq, iIm) = setdiff(1 : 3, [idx(2, iSeq, iIm - 1) t(rr(1))]);
            end
            % otherwise ambiguous since t(rr(1)) could be equal to
            % idx(2,iSeq,iIm-1) LG 07/18/13
            
            idx(3, iSeq, iIm) = setdiff(1 : 3, idx(1 : 2, iSeq, iIm));
        else
            for i = 1 : 3
                idx(i, iSeq, iIm) = setdiff(1 : 3, idx(i, iSeq, iIm - (1 : 2)));
            end
        end
        k = mod(k + 1, 3);
        imNum(:, iSeq, iIm) = params.imPerTrial * (iSeq - 1) + iIm;
        
    end
end
nCond = 3 * params.seqGroupsPerSession;
idx = reshape(idx, nCond, params.imPerTrial);
imNum = reshape(imNum, nCond, params.imPerTrial);
stats = 'npw';
for iCond = 1 : nCond
    conditions(iCond).stat = stats(idx(iCond, :));
    conditions(iCond).statIndex = idx(iCond, :);
    conditions(iCond).imNum = imNum(iCond, :);
end
r.conditions = conditions;
r = resetPool(r);

