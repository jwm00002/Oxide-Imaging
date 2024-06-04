[mapData,mapEnergies] = XraySpecFunctions.loadAllMapData('D4 map data');
%run 3 data shifts
%data 3.8 4.0 4.2
[one.Nb2O5,one.NbO2,one.NbO,one.residual_avg] = XraySpecFunctions.xray_percentAnalysis(mapData,mapEnergies,3.8,"NewNbref.txt",0,"nbsi2.txt",0.25,"Nb2O5 Data.txt",0,"NbO2 Data.txt",0,"Nb2O5 Data.txt",0);
[two.Nb2O5,two.NbO2,two.NbO,two.residual_avg] = XraySpecFunctions.xray_percentAnalysis(mapData,mapEnergies,4.0,"NewNbref.txt",0,"nbsi2.txt",0.25,"Nb2O5 Data.txt",0,"NbO2 Data.txt",0,"Nb2O5 Data.txt",0);
[three.Nb2O5,three.NbO2,three.NbO,three.residual_avg] = XraySpecFunctions.xray_percentAnalysis(mapData,mapEnergies,4.2,"NewNbref.txt",0,"nbsi2.txt",0.25,"Nb2O5 Data.txt",0,"NbO2 Data.txt",0,"Nb2O5 Data.txt",0);
%check which is closest to desired percentages
index = find(interp1([one.Nb2O5,two.Nb2O5,three.Nb2O5],[one.Nb2O5,two.Nb2O5,three.Nb2O5],0.85));
if index == 1
    
elseif index == 2
    
elseif index == 3

end
%go to next iteration step and repeat for other references
%NbO -1 -1.3 -1.6
%NbO2 -0.2 0.2 1

%85 Nb2O5
