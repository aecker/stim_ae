function writeStruct(tcp,outStruct)
% Write Matlab structure to the network connection.
% AE 2007-10-04

% number of parameters
fields = fieldnames(outStruct);
n = length(fields);
pnet(tcp.con,'write',int32(n),'int32');

% send them individually
for i = 1:n
    
    % field name
    pnet(tcp.con,'write',int32(length(fields{i})),'int32')
    pnet(tcp.con,'write',fields{i},'char')
    
    % element type & size
    curField = outStruct.(fields{i});
    elemType = getTypeConstant(tcp,class(curField));
    pnet(tcp.con,'write',int32(elemType),'int32')
    dim1 = size(curField,1);
    pnet(tcp.con,'write',int32(dim1),'int32')
    dim2 = size(curField,2);
    pnet(tcp.con,'write',int32(dim2),'int32')
    
    % element data
    switch elemType
        case getTypeConstant(tcp,'double')
            pnet(tcp.con,'write',curField',[dim2 dim1],'double')
        case getTypeConstant(tcp,'string')
            for j = 1:dim1
                for k = 1:dim2
                    pnet(tcp.con,'write',int32(length(curField{j,k})),'int32')
                    pnet(tcp.con,'write',curField{j,k},'char')
                end
            end
        case getTypeConstant(tcp,'int32')
            pnet(tcp.con,'write',curField',[dim2 dim1],'int32')
        case getTypeConstant(tcp,'char')
            pnet(tcp.con,'write',curField',[dim2 dim1],'char')
    end
end
            