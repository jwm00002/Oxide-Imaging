clc;clear; close all;
figure
%read map data
[data,energy(2)] = XraySpecFunctions.readMapFile("D4_1x1_mini_DT001.xrf",'D4');
avg(2) = mean(data,"all");
[data,energy(3)] = XraySpecFunctions.readMapFile("D4_1x1_mini_DT002.xrf",'D4');
avg(3) = mean(data,"all");
[data,energy(4)] = XraySpecFunctions.readMapFile("D4_1x1_mini_DT003.xrf",'D4');
avg(4) = mean(data,"all");
[data,energy(5)] = XraySpecFunctions.readMapFile("D4_1x1_mini_DT004.xrf",'D4');
avg(5) = mean(data,"all");
[data,energy(6)] = XraySpecFunctions.readMapFile("D4_1x1_mini_DT005.xrf",'D4');
avg(6) = mean(data,"all");
[data,energy(7)] = XraySpecFunctions.readMapFile("D4_1x1_mini_DT006.xrf",'D4');
avg(7) = mean(data,"all");
[data,energy(8)] = XraySpecFunctions.readMapFile("D4_1x1_mini_DT007.xrf",'D4');
avg(8) = mean(data,"all");
[data,energy(9)] = XraySpecFunctions.readMapFile("D4_1x1_mini_DT008.xrf",'D4');
avg(9) = mean(data,"all");
[data,energy(10)] = XraySpecFunctions.readMapFile("D4_1x1_mini_DT009.xrf",'D4');
avg(10) = mean(data,"all");
[data,energy(11)] = XraySpecFunctions.readMapFile("D4_1x1_mini_DT010.xrf",'D4');
avg(11) = mean(data,"all");
[data,energy(12)] = XraySpecFunctions.readMapFile("D4_1x1_mini_DT011.xrf",'D4');
avg(12) = mean(data,"all");
[data,energy(13)] = XraySpecFunctions.readMapFile("D4_1x1_mini_DT012.xrf",'D4');
avg(13) = mean(data,"all");
[data,energy(14)] = XraySpecFunctions.readMapFile("D4_1x1_mini_DT013.xrf",'D4');
avg(14) = mean(data,"all");
[data,energy(15)] = XraySpecFunctions.readMapFile("D4_1x1_mini_DT014.xrf",'D4');
avg(15) = mean(data,"all");
[data,energy(16)] = XraySpecFunctions.readMapFile("D4_1x1_mini_DT015.xrf",'D4');
avg(16) = mean(data,"all");
[data,energy(17)] = XraySpecFunctions.readMapFile("D4_1x1_mini_DT016.xrf",'D4');
avg(17) = mean(data,"all");
%plot vertical lines at each energy from map data
label = {avg(2),avg(3),avg(4),avg(5),avg(6),avg(7),avg(8),avg(9),avg(10),avg(11),avg(12),avg(13),avg(14),avg(15),avg(16),avg(17)};
xline(energy(2:17),'-',label)
title("D4")

figure
%read map data
[data,energy(1)] = XraySpecFunctions.readMapFile("GW270_1um_94x66_DT000.xrf",'GW');
avg(1) = mean(data,"all");
[data,energy(2)] = XraySpecFunctions.readMapFile("GW270_1um_94x66_DT001.xrf",'GW');
avg(2) = mean(data,"all");
[data,energy(3)] = XraySpecFunctions.readMapFile("GW270_1um_94x66_DT002.xrf",'GW');
avg(3) = mean(data,"all");
[data,energy(4)] = XraySpecFunctions.readMapFile("GW270_1um_94x66_DT003.xrf",'GW');
avg(4) = mean(data,"all");
[data,energy(5)] = XraySpecFunctions.readMapFile("GW270_1um_94x66_DT004.xrf",'GW');
avg(5) = mean(data,"all");
[data,energy(6)] = XraySpecFunctions.readMapFile("GW270_1um_94x66_DT005.xrf",'GW');
avg(6) = mean(data,"all");
[data,energy(7)] = XraySpecFunctions.readMapFile("GW270_1um_94x66_DT006.xrf",'GW');
avg(7) = mean(data,"all");
[data,energy(8)] = XraySpecFunctions.readMapFile("GW270_1um_94x66_DT007.xrf",'GW');
avg(8) = mean(data,"all");
[data,energy(9)] = XraySpecFunctions.readMapFile("GW270_1um_94x66_DT008.xrf",'GW');
avg(9) = mean(data,"all");
[data,energy(10)] = XraySpecFunctions.readMapFile("GW270_1um_94x66_DT009.xrf",'GW');
avg(10) = mean(data,"all");
[data,energy(11)] = XraySpecFunctions.readMapFile("GW270_1um_94x66_DT011.xrf",'GW');
avg(11) = mean(data,"all");
[data,energy(12)] = XraySpecFunctions.readMapFile("GW270_1um_94x66_DT012.xrf",'GW');
avg(12) = mean(data,"all");
[data,energy(13)] = XraySpecFunctions.readMapFile("GW270_1um_94x66_DT013.xrf",'GW');
avg(13) = mean(data,"all");
[data,energy(14)] = XraySpecFunctions.readMapFile("GW270_1um_94x66_DT014.xrf",'GW');
avg(14) = mean(data,"all");
label = {avg(1),avg(2),avg(3),avg(4),avg(5),avg(6),avg(7),avg(8),avg(9),avg(10),avg(11),avg(12),avg(13),avg(14)};
xline(energy(1:14),'-',label)
title("GW")

%which map makes a greater impact on the final percentage
%do each energy level seperately and do it in chunks(pre edge, peak, post edge) and see what result is
%by splitting it up we aren't really getting a result because for each
%point the answer will be different unless we do it all at the same time
%and see which fits all of them best
%by splitting it up we get a result for that energy level but we can't
%really combine the results

%linear combinations of spectrum to fit a sample spectrum
%setup lsqnonlin problem basically the same except only with spectrums only

%run mapping code on GW2 and W samples