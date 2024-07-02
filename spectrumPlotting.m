clc;clear;close all;
%plots the energy levels of each map and the average intensity at each
%energy level
figure
%read map data


[mapData, mapEnergies] = XraySpecFunctions.loadAllMapData("D4 map data","D4");
mapData = XraySpecFunctions.normalizeMaps(mapData,"D4");
for i = 1:length(mapEnergies)
    avg(i) = mean(mapData(:,:,i),[1 2]);
    energies(i) = mapEnergies(i);
end
label = {avg(1),avg(2),avg(3),avg(4),avg(5),avg(6),avg(7),avg(8),avg(9),avg(10),avg(11),avg(12),avg(13),avg(14),avg(15),avg(16),avg(17),avg(18)};
xline(energies,'-',label)
xlim([2360 2385])
title("D4")
clear
figure
[mapData, mapEnergies] = XraySpecFunctions.loadAllMapData("GW270 map data","GW70");
mapData = XraySpecFunctions.normalizeMaps(mapData,"GW70");
for i = 1:length(mapEnergies)
    avg(i) = mean(mapData(:,:,i),[1 2]);
    energies(i) = mapEnergies(i);
end
label = {avg(1),avg(2),avg(3),avg(4),avg(5),avg(6),avg(7),avg(8),avg(9),avg(10),avg(11),avg(12),avg(13),avg(14)};
xline(energies,'-',label)
xlim([2360 2385])
title("GW70")
clear
figure
[mapData, mapEnergies] = XraySpecFunctions.loadAllMapData("GW2500","GW500");
mapData = XraySpecFunctions.normalizeMaps(mapData,"GW500");
for i = 1:length(mapEnergies)
    avg(i) = mean(mapData(:,:,i),[1 2]);
    energies(i) = mapEnergies(i);
end
label = {avg(1),avg(2),avg(3),avg(4),avg(5),avg(6),avg(7),avg(8),avg(9),avg(10),avg(11),avg(12),avg(13),avg(14),avg(15),avg(16),avg(17),avg(18)};
xline(energies,'-',label)
xlim([2360 2385])
title("GW500")
clear
figure
[mapData, mapEnergies] = XraySpecFunctions.loadAllMapData("W1","W");
mapData = XraySpecFunctions.normalizeMaps(mapData,"W");
for i = 1:length(mapEnergies)
    avg(i) = mean(mapData(:,:,i),[1 2]);
    energies(i) = mapEnergies(i);
end
label = {avg(1),avg(2),avg(3),avg(4),avg(5),avg(6),avg(7),avg(8),avg(9),avg(10),avg(11),avg(12),avg(13),avg(14),avg(15),avg(16),avg(17),avg(18)};
xline(energies,'-',label)
xlim([2360 2385])
title("W1")
clear
figure
[mapData, mapEnergies] = XraySpecFunctions.loadAllMapData("W2L","W");
mapData = XraySpecFunctions.normalizeMaps(mapData,"W");
for i = 1:length(mapEnergies)
    avg(i) = mean(mapData(:,:,i),[1 2]);
    energies(i) = mapEnergies(i);
end
label = {avg(1),avg(2),avg(3),avg(4),avg(5),avg(6),avg(7),avg(8),avg(9),avg(10),avg(11),avg(12),avg(13),avg(14),avg(15),avg(16),avg(17),avg(18)};
xline(energies,'-',label)
xlim([2360 2385])
title("W2L")
clear
figure
[mapData, mapEnergies] = XraySpecFunctions.loadAllMapData("W2L_A","W");
mapData = XraySpecFunctions.normalizeMaps(mapData,"W");
for i = 1:length(mapEnergies)
    avg(i) = mean(mapData(:,:,i),[1 2]);
    energies(i) = mapEnergies(i);
end
label = {avg(1),avg(2),avg(3),avg(4),avg(5),avg(6),avg(7),avg(8),avg(9),avg(10),avg(11),avg(12),avg(13),avg(14),avg(15),avg(16),avg(17)};
xline(energies,'-',label)
xlim([2360 2385])
title("W2L_A")
clear
figure
[mapData, mapEnergies] = XraySpecFunctions.loadAllMapData("W2R","W");
mapData = XraySpecFunctions.normalizeMaps(mapData,"W");
for i = 1:length(mapEnergies)
    avg(i) = mean(mapData(:,:,i),[1 2]);
    energies(i) = mapEnergies(i);
end
label = {avg(1),avg(2),avg(3),avg(4),avg(5),avg(6),avg(7),avg(8),avg(9),avg(10),avg(11),avg(12),avg(13),avg(14),avg(15),avg(16),avg(17),avg(18)};
xline(energies,'-',label)
xlim([2360 2385])
title("W2R")
clear
figure
[mapData, mapEnergies] = XraySpecFunctions.loadAllMapData("W2R_B","W");
mapData = XraySpecFunctions.normalizeMaps(mapData,"W");
for i = 1:length(mapEnergies)
    avg(i) = mean(mapData(:,:,i),[1 2]);
    energies(i) = mapEnergies(i);
end
label = {avg(1),avg(2),avg(3),avg(4),avg(5),avg(6),avg(7),avg(8),avg(9),avg(10),avg(11),avg(12),avg(13),avg(14),avg(15),avg(16),avg(17)};
xline(energies,'-',label)
xlim([2360 2385])
title("W2R_B")
