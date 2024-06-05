clc;clear;close all;
Nb2O5Percent = zeros(1,337);
NbO2Percent = zeros(1,337);
NbOPercent = zeros(1,337);
LowRegion = zeros(1,337);
residualAvg = zeros(1,337);
dataShift = zeros(1,337);
NbOShift = zeros(1,337);
NbO2Shift = zeros(1,337);
[mapData,mapEnergies] = XraySpecFunctions.loadAllMapData('D4 map data');
l = 1;
tic
%loop through data shifts
for i = -3.8:-0.1:-4.8
%loop through each NbO shift
for j = -1:-0.1:-1.6
    %lop through each NbO2 shift
    for k = -0.2:0.1:1
        disp("Run: "+l)
        [Nb2O5,NbO2,NbO,residual_avg,lowRegionAvg] = XraySpecFunctions.xray_percentAnalysis(mapData,mapEnergies,i,"NewNbref.txt",0,"nbsi2.txt",0.25,"Nb2O5 Data.txt",0,"NbO2 Data.txt",k,"Nb2O5 Data.txt",j);
        Nb2O5Percent(l) = Nb2O5;
        NbO2Percent(l) = NbO2;
        NbOPercent(l) = NbO;
        LowRegion(l) = lowRegionAvg;
        residualAvg(l) = residual_avg;
        dataShift(l) = i;
        NbOShift(l) = j;
        NbO2Shift(l) = k;
        l = l+1;
    end
end
end
toc
%write table to excel file
T = table(dataShift',NbOShift',NbO2Shift',Nb2O5Percent',NbO2Percent',NbOPercent',LowRegion',residualAvg');
writetable(T,'NboptimizationData.xls','WriteRowNames',true,'Sheet','NewNbRef');