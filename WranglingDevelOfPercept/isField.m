function isField( structure, fieldName )
%isField checks to see if a data structure contains a given fieldName
%   isField(structure,fieldName)
%       structure: a data structure
%       fieldName: a string with the name of the field you're looking for
%   throws an error message saying that fieldName is not in the structure
%
%AR Oct 2018

actualFields = fieldnames(structure); %All fields in the structure
%Checking to see if fieldName is in actualFields
if any(strcmp(actualFields,fieldName))
    return
end
%If function hasn't returned yet, then fieldName is not in structure
error([fieldName ' is not a field of this structure'])
end