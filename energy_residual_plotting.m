clc;clear;close all;
[mapData, mapEnergies]= XraySpecFunctions.loadAllMapData("GW270 old");
mapData = XraySpecFunctions.normalizeLower(mapData,"new");
metal_ref_spectra = XraySpecFunctions.readSpectraFile("Smoothed W2L data.txt");
Nb2O5_ref_spectra = XraySpecFunctions.readSpectraFile("Nb2O5PowderNew.txt");
NbO2_ref_spectra = XraySpecFunctions.readSpectraFile("NbO2PowderNew.txt");
NbO_ref_spectra = XraySpecFunctions.readSpectraFile("NbOPowderNew.txt");

metal_ref = XraySpecFunctions.create_referenceArray(mapEnergies,metal_ref_spectra);
Nb2O5_ref = XraySpecFunctions.create_referenceArray(mapEnergies,Nb2O5_ref_spectra);
NbO2_ref = XraySpecFunctions.create_referenceArray(mapEnergies,NbO2_ref_spectra);
NbO_ref = XraySpecFunctions.create_referenceArray(mapEnergies,NbO_ref_spectra);

%average each energy level
averages(1:length(mapEnergies)) = mean(mapData(:,:,1:length(mapEnergies)),[1 2]);
%loop and solve for each energy level
for i = 1:length(mapEnergies)
    func = @(x) [averages(i)-x(1).*metal_ref(i,2)-x(2).*Nb2O5_ref(i,2)-x(3).*NbO2_ref(i,2)-x(4).*NbO_ref(i,2); 1-x(1)-x(2)-x(3)-x(4)];
    opts = optimoptions("lsqnonlin",'display','off');
    problem = createOptimProblem('lsqnonlin','objective',func,'x0',[0 0 0 0],'lb',[0 0 0 0],'ub',[1 1 1 1],'options',opts);
    %output step difference with everything else
    [y,resnorm,~,~,~,~,jacobian] = lsqnonlin(problem);
    out(i) = resnorm;
end
plot(mapEnergies,out)
xlabel("Energy")
ylabel("Residual")
title("Residual Per Energy Level")