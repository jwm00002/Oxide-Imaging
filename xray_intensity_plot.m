clc;clear;close all;
%              XraySpecFunctions.xray_mapAnalysis(map data folder,map type,map shift,metal ref,metal shift,Nb2O5 ref,Nb2O5 shift,NbO2 ref,NbO2 shift,NbO ref,NbO shift)
[og_shift] = XraySpecFunctions.xray_mapAnalysis("D4 new","new",0,"NbFoilNew.txt",0,"Nb2O5PowderNew.txt",0,"NbO2PowderNew.txt",0,"NbOPowderNew.txt",0);
%new spectrum coming so no shifts needed later