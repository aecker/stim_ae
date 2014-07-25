function r = init(r, params)
% Initialize randomization  
% LG 07/23/13



% init for 3 statistical variants: 
idx = zeros(3, params.seqGroupsPerSession, params.imPerTrial);
imNum = idx;
nIm = params.imPerTrial;
iIm = [(1 : 7); (8 : 14); (15 : 21)];  
for iSeq = 1 : params.seqGroupsPerSession
    k = 0;
    for iIm = 1 : params.imPerTrial
        if k == 0
            idx(:, iSeq, iIm) = randperm(3);
        elseif k == 1
            t = setdiff(1 : 3, idx(1,iSeq, iIm - 1)); 
            
            rr = randperm(2); 
            idx(1, iSeq, iIm) = t(rr(1));
            
            if t(rr(1)) == idx(2, iSeq, iIm - 1)
                idx(2, iSeq, iIm) = setdiff(1 : 3, [idx(1 : 2, iSeq, iIm - 1)' t(rr(1))]);
            else
                idx(2, iSeq, iIm) = setdiff(1 : 3, [idx(2, iSeq, iIm - 1) t(rr(1))]);
            end
            
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

nCond = 4 * params.seqGroupsPerSession;
idx = reshape(idx, nCond, params.imPerTrial);
imNum = reshape(imNum, nCond, params.imPerTrial);
stats = 'npwo';
for iCond = 1 : nCond
    conditions(iCond).stat = stats(idx(iCond, :));
    conditions(iCond).statIndex = idx(iCond, :);
    conditions(iCond).imNum = imNum(iCond, :);
end

% old init for 3 statistical variants: 
% idx = zeros(3, params.seqGroupsPerSession, params.imPerTrial);
% imNum = idx;
% for iSeq = 1 : params.seqGroupsPerSession
%     k = 0;
%     for iIm = 1 : params.imPerTrial
%         if k == 0
%             idx(:, iSeq, iIm) = randperm(3);
%         elseif k == 1
%             %t = setdiff(r, idx(1,iSeq, iIm - 1));
%             t = setdiff(1 : 3, idx(1,iSeq, iIm - 1)); %exchanged 2nd and 3rd dimension also what does the 'r' do there? Lg 07/18/13
%             
%             %r = randperm(2);
%             rr = randperm(2); %call it rr since r is the randomization object also changed in the following LG 07/18/13
%             idx(1, iSeq, iIm) = t(rr(1));
%             
%             %idx(2, iSeq, iIm) = setdiff(1 : 3, [idx(2, iSeq, iIm - 1) t(rr(1))]);
%             if t(rr(1)) == idx(2, iSeq, iIm - 1)
%                 idx(2, iSeq, iIm) = setdiff(1 : 3, [idx(1 : 2, iSeq, iIm - 1)' t(rr(1))]);
%             else
%                 idx(2, iSeq, iIm) = setdiff(1 : 3, [idx(2, iSeq, iIm - 1) t(rr(1))]);
%             end
%             % otherwise ambiguous since t(rr(1)) could be equal to
%             % idx(2,iSeq,iIm-1) LG 07/18/13
%             
%             idx(3, iSeq, iIm) = setdiff(1 : 3, idx(1 : 2, iSeq, iIm));
%         else
%             for i = 1 : 3
%                 idx(i, iSeq, iIm) = setdiff(1 : 3, idx(i, iSeq, iIm - (1 : 2)));
%             end
%         end
%         k = mod(k + 1, 3);
%         imNum(:, iSeq, iIm) = params.imPerTrial * (iSeq - 1) + iIm;
%         
%     end
% end
% nCond = 3 * params.seqGroupsPerSession;
% idx = reshape(idx, nCond, params.imPerTrial);
% imNum = reshape(imNum, nCond, params.imPerTrial);
% stats = 'npw';
% for iCond = 1 : nCond
%     conditions(iCond).stat = stats(idx(iCond, :));
%     conditions(iCond).statIndex = idx(iCond, :);
%     conditions(iCond).imNum = imNum(iCond, :);
% end
r.conditions = conditions;
r = resetPool(r);

end


% code for correct randomization with 4 statistical variants
% LG 07-30-13

% idx = zeros(4, params.seqGroupsPerSession, params.imPerTrial);
% imNum = idx;
% nIm = params.imPerTrial;
% iIm = [(1 : 7); (8 : 14); (15 : 21)];  
% for iSeq = 1 : params.seqGroupsPerSession
%     c0 = randperm(4);
%     fN = randperm(24);
%     sN = randperm(24);
%     fstBlock = getPerm(c0,fN(1));
%     sndBlock = getPerm(c0,sN(1));
%     idx(:, iSeq, 1 : 4) = fstBlock;
%     idx(:, iSeq, 5 : nIm) = sndBlock(:, 1 : (nIm - 4));
%     imNum(:, iSeq, 1 : nIm) = kron(ones(4,1),iIm(iSeq, :));
% end
% 
% nCond = 4 * params.seqGroupsPerSession;
% idx = reshape(idx, nCond, params.imPerTrial);
% imNum = reshape(imNum, nCond, params.imPerTrial);
% stats = 'npwo';
% for iCond = 1 : nCond
%     conditions(iCond).stat = stats(idx(iCond, :));
%     conditions(iCond).statIndex = idx(iCond, :);
%     conditions(iCond).imNum = imNum(iCond, :);
% end
% r.conditions = conditions;
% r = resetPool(r);
% 
% end
% 
% 
% function out = getPerm(c0, n)
% % ensures the correct randomization such that in a 4x4 (imNum x statistical variant) Block there is only one variant in each direction
% % LG 07/23/13
% 
% A = c0(1);
% B = c0(2);
% C = c0(3);
% D = c0(4);
% 
% % 9 compatible columns
% c1 = [B A D C];
% c2 = [B C D A];
% c3 = [B D A C];
% c4 = [C A D B];
% c5 = [C D A B];
% c6 = [C D B A];
% c7 = [D A B C];
% c8 = [D C A B];
% c9 = [D C B A];
% 
% %24 compatible combinations of columns 6 x 4
% comb(1).struct = [c0; c1; c5; c9];
% comb(2).struct = comb(1).struct(:,[1 4 2 3]);
% comb(3).struct = comb(1).struct(:,[1 3 4 2]);
% comb(4).struct = comb(1).struct(:,[1 2 4 3]);
% comb(5).struct = comb(1).struct(:,[1 3 2 4]);
% comb(6).struct = comb(1).struct(:,[1 4 3 2]);
% 
% comb(7).struct = [c0; c1; c6; c8];
% comb(8).struct = comb(7).struct(:,[1 4 2 3]);
% comb(9).struct = comb(7).struct(:,[1 3 4 2]);
% comb(10).struct = comb(7).struct(:,[1 2 4 3]);
% comb(11).struct = comb(7).struct(:,[1 3 2 4]);
% comb(12).struct = comb(7).struct(:,[1 4 3 2]);
% 
% comb(13).struct = [c0; c2; c5; c7];
% comb(14).struct = comb(13).struct(:,[1 4 2 3]);
% comb(15).struct = comb(13).struct(:,[1 3 4 2]);
% comb(16).struct = comb(13).struct(:,[1 2 4 3]);
% comb(17).struct = comb(13).struct(:,[1 3 2 4]);
% comb(18).struct = comb(13).struct(:,[1 4 3 2]);
% 
% comb(19).struct = [c0; c3; c4; c9];
% comb(20).struct = comb(19).struct(:,[1 4 2 3]);
% comb(21).struct = comb(19).struct(:,[1 3 4 2]);
% comb(22).struct = comb(19).struct(:,[1 2 4 3]);
% comb(23).struct = comb(19).struct(:,[1 3 2 4]);
% comb(24).struct = comb(19).struct(:,[1 4 3 2]);
% 
% out = comb(n).struct;
% end
