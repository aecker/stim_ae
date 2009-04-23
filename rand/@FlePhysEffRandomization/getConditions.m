function c = getConditions(r,cNdx)

if nargin < 2
    c = r.conditions;
else
    c = r.conditions(cNdx);
end
