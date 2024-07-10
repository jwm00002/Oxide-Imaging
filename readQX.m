clc;clear;close all;
%open .qz file
file = fopen("wafer2_center_068.qx",'r');
%read header until we get to the line before the energies
line = fgets(file);
while(~strcmp(subsref(split(line), struct('type', '()', 'subs', {{1}})),"Offsets="))
    line = fgets(file);
end
%read energy line
line = fgets(file);
energies = split(line);
%save everything but the first item
energies=energies(2:end);
%read until start of data
line = fgets(file);
while(~strcmp(subsref(split(line), struct('type', '()', 'subs', {{1}})),"**********"))
    line = fgets(file);
end
T = table(energies);
while ~feof(file)
    %read bracketed numbers
    line = fgets(file);
    %read data line 1
    line = fgets(file);
    %save
    dataLine1Block = split(line);
    %read data line 2
    line = fgets(file);
    %save
    dataLine2Block = split(line);
    %read empty line
    line = fgets(file);
    T = addvars(T,dataLine1Block,dataLine2Block);
end
fclose(file);
writetable(T,'wafer2_center_068.xls')
%save to excel file