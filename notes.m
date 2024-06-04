%check preedge and post edge difference and
%compare first and second maps used for subtraction
%and see if metal gets smaller in channels

%try running with no NbO

%open and normalize D4 sample data
%{
spot2 = XraySpecFunctions.readSpectraFile("D4_spot2_006.r");
spot2(:,2) = spot2(:,2) - spot2(1,2);
spot2(:,2) = spot2(:,2)*(1/spot2(303,2));
spot3 = XraySpecFunctions.readSpectraFile("D4_spot3_007.r");
spot3(:,2) = spot3(:,2) - spot3(1,2);
spot3(:,2) = spot3(:,2)*(1/spot3(323,2));
spot4 = XraySpecFunctions.readSpectraFile("D4_spot4_000.r");
spot4(:,2) = spot4(:,2) - spot4(1,2);
spot4(:,2) = spot4(:,2)*(1/spot4(355,2));
spot5 = XraySpecFunctions.readSpectraFile("D4_spot5_000.r");
spot5(:,2) = spot5(:,2) - spot5(1,2);
spot5(:,2) = spot5(:,2)*(1/spot5(353,2));
spot6 = XraySpecFunctions.readSpectraFile("D4_spot6_000.r");
spot6(:,2) = spot6(:,2) - spot6(1,2);
spot6(:,2) = spot6(:,2)*(1/spot6(327,2));
spot7 = XraySpecFunctions.readSpectraFile("D4_spot7_000.r");
spot7(:,2) = spot7(:,2) - spot7(1,2);
spot7(:,2) = spot7(:,2)*(1/spot7(306,2));
%}