clc;clear;close all;
%                        XraySpecFunctions.xray_mapAnalysis(map data folder,map shift,metal ref,metal shift,Nb2O5 ref,Nb2O5 shift,NbO2 ref,NbO2 shift,NbO ref,NbO shift)
[mapData, mapEnergies] = XraySpecFunctions.xray_mapAnalysis("D4 map data",-4.1,"NewNbref.txt",0,"nbsi2.txt",0,"Nb2O5 Data.txt",0,"NbO2 Data.txt",0.3,"Nb2O5 Data.txt",-2.6);

%create an optimization problem for the custom function to find best shift
%values?