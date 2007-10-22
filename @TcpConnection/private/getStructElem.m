function params = getStructElem(tcp,params)
%{INT32:struct_name_length}{CHAR_ARRAY:struct_name}{INT32:elem_type}{INT32:elem_size}{INT32:array_dim}{INT32:array_dim}


nameLength = double(pnet(tcp.con,'read',1,'int32'));
name = pnet(tcp.con,'read',nameLength,'char');
elemType = double(pnet(tcp.con,'read',1,'int32'));
dim1 = double(pnet(tcp.con,'read',1,'int32'));
dim2 = double(pnet(tcp.con,'read',1,'int32'));

fprintf('TcpConnection:getStructElem\n')
fprintf('  name = %s\n',name)
fprintf('  type = %d\n',elemType)
fprintf('  dims = [%d,%d]\n',dim1,dim2)

%data = pnet(con,'read','noblock','view')

switch elemType
    case getTypeConstant(tcp,'double')
        % This is for decoding an array of doubles
        params.(name) = pnet(tcp.con,'read',[dim2 dim1],'double')';
    case getTypeConstant(tcp,'string')
        % This is for decoding an array of strings
        for i = 1:dim1
            for j = 1:dim2
                strLen = double(pnet(tcp.con,'read',1,'int32'));
                params.(name){i,j} = pnet(tcp.con,'read',strLen,'char');
            end
        end                
    case getTypeConstant(tcp,'int32')
        % This is for decoding an array of I32
        params.(name) = double(pnet(tcp.con,'read',[dim2 dim1],'int32')');
    case getTypeConstant(tcp,'char')
        % This is for decoding an array of char
        params.(name) = pnet(tcp.con,'read',[dim2 dim1],'char')';
    otherwise
        error('Unsupported data type from LabView: name: %s elemType: %d', name, elemType);
end
