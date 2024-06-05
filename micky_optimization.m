[mapData,mapEnergies] = XraySpecFunctions.loadAllMapData('D4 map data');
%run 3 data shifts
%data 3.8 4.0 4.2
mapShift = 0;
diff = 100;
for i = -3.8:-0.2:-4.2
    [Nb2O5,NbO2,NbO,residual_avg] = XraySpecFunctions.xray_percentAnalysis(mapData,mapEnergies,i,"NewNbref.txt",0,"nbsi2.txt",0.25,"Nb2O5 Data.txt",0,"NbO2 Data.txt",0,"Nb2O5 Data.txt",0);
    if abs(0.85-Nb2O5)<abs(diff)
        mapShift = i;
        diff = 0.85-Nb2O5;
    end
end
%{
if diff>0 % difference is positive so Nb2O5 is less than 0.85
    %high
    
    %low
    
    %diff/high-low
    weight = 1-(abs(diff)/(mapShiftHigh-mapShift));
    mapShift = (weight*mapShift+(1-weight)*mapShiftHigh);
elseif diff<0 %difference is negative so closest is larger than data
    %high
    
    %low

    weight = 1-(abs(diff)/(mapShift-mapShiftLow));
    mapShift = (weight*mapShift+(1-weight)*mapShiftLow);
end
%}
%go to next iteration step and repeat for other references
%NbO -1 -1.3 -1.6
NbOShift = 0;
diff = 100;
for i = -1:-0.3:-1.6
    [Nb2O5,NbO2,NbO,residual_avg] = XraySpecFunctions.xray_percentAnalysis(mapData,mapEnergies,mapShift,"NewNbref.txt",0,"nbsi2.txt",0.25,"Nb2O5 Data.txt",0,"NbO2 Data.txt",0,"Nb2O5 Data.txt",i);
    if abs(0.85-Nb2O5)<abs(diff)
        NbOshift = i;
        diff = 0.85-Nb2O5;
    end
end
%NbO2 -0.2 0.2 1
NbO2Shift = 0;
diff = 100;
for i = -0.2:0.2:1
    [Nb2O5,NbO2,NbO,residual_avg] = XraySpecFunctions.xray_percentAnalysis(mapData,mapEnergies,mapShift,"NewNbref.txt",0,"nbsi2.txt",0.25,"Nb2O5 Data.txt",0,"NbO2 Data.txt",i,"Nb2O5 Data.txt",NbOshift);
    if abs(0.85-Nb2O5)<abs(diff)
        NbO2shift = i;
        diff = 0.85-Nb2O5;
    end
end
[mapData, mapEnergies] = XraySpecFunctions.xray_mapAnalysis("D4 map data",mapShift,"NewNbref.txt",0,"nbsi2.txt",0.25,"Nb2O5 Data.txt",0,"NbO2 Data.txt",NbO2Shift,"Nb2O5 Data.txt",NbOshift);