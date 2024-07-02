clc;clear;close all;
[mapData,mapEnergies] = XraySpecFunctions.loadAllMapData('D4 map data','D4');
l = 1;
tic
%lop through each NbO2 shift
for i = 1:17
    for k = 1:16
        if k >= i
            skipData(:,:,k) = mapData(:,:,k+1);
            skipEnergies(k) = mapEnergies(k+1);
        else
            skipData(:,:,k) = mapData(:,:,k);
            skipEnergies(k) = mapEnergies(k);
        end
    end
    [Nb2O5,NbO2,NbO,residual_avg,lowRegionAvg] = XraySpecFunctions.xray_percentAnalysis(skipData,"D4",skipEnergies,-4.1,"NewNbref.txt",0,"nbsi2.txt",0.25,"Nb2O5 Data.txt",0,"NbO2 Data.txt",-0.4,"Nb2O5 Data.txt",-2.8);
    Nb2O5Percent(l) = Nb2O5;
    NbO2Percent(l) = NbO2;
    NbOPercent(l) = NbO;
    LowRegion(l) = lowRegionAvg;
    residualAvg(l) = residual_avg;
    mapSkipped(l) = i;
    l = l+1;
end
toc
%write table to excel file
T = table(mapSkipped',Nb2O5Percent',NbO2Percent',NbOPercent',LowRegion',residualAvg');
writetable(T,'energySkipping.xls','WriteVariableNames',true,'Sheet','D4');