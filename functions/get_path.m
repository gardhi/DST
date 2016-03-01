function [ path ] = get_path( desiredFolder )
%GETPATH Gets path of folder
%   folder must be in the same folder as the main function

filename = mfilename();
path = mfilename('fullpath');
path = path(1:end-length(filename));

% Making sure the slashes are right
operating_system = getenv('OS');
if strcmp(operating_system(1:7), 'Windows')
    path = [path '..\database\' desiredFolder '\'];
else
    path = [path '../database\' desiredFolder '/']; 
end


end

