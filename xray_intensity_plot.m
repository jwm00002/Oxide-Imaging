clc;clear;close all;
%            XraySpecFunctions.xray_mapAnalysis(map data folder,map shift,metal ref,metal shift,Nb2O5 ref,Nb2O5 shift,NbO2 ref,NbO2 shift,NbO ref,NbO shift)
[og_shift] = XraySpecFunctions.xray_mapAnalysis("D4 map data",-4.3,"foil data.txt",0,"nbsi2.txt",0.25,"Nb2O5 Data.txt",0,"NbO2 Data.txt",-0.1,"Nb2O5 Data.txt",-1.6);
%new spectrum coming so no shifts needed later