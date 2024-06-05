classdef XraySpecFunctions
    methods(Static)

        function NbO_ref = NbO_curvefit()
            h=3.5;
            w=1.1;
            x = 1:1:2400;
            %create step function
            s = 0.18*atan(x-2367.6)+0.27;
            %s(1:1:205) = s(1:1:205)+1.59;
            %create main gaussian
            g1 = XraySpecFunctions.myGauss(x,2371.6,w,7/h);
            %create smaller gaussian
            g2 = XraySpecFunctions.myGauss(x,2374.2,2*w,3.2/h);
            g3 = XraySpecFunctions.myGauss(x,2380.9,1.6*w,0.7/h);
            g4 = XraySpecFunctions.myGauss(x,2387.8,w,0.5/h);
            g5 = XraySpecFunctions.myGauss(x,2396,1.5*w,0.35/h);
            NbO(2,:) = g1+g2+g3+g4+g5+s;
            NbO(1,:) = x;
            NbO = NbO';
            NbO_ref(:,1) = NbO(2300:end,1);
            NbO_ref(:,2) = NbO(2300:end,2);
        end

        function Nb_ref = Nb_curvefit()
            %bring down amplitude to fit map averages better
            x = 2310:2426;
            %create step function
            s = atan(x-2373);
            s(1:64) = s(1:64)+1.59;
            s(65:end) = s(65:end)-0.5;
            s(64) = s(65);
            %create main gaussian
            g1 = XraySpecFunctions.myGauss(x,2370.5,2,3.4);
            %create smaller gaussian
            g2 = XraySpecFunctions.myGauss(x,2375,5,0.9);
            %add everything together
            Nb_ref(2,:) = g1+g2+s;
            %apply slope to end
            %Nb_ref(2,274:end) = Nb_ref(2,274:end).*y-0.73;
            Nb_ref(1,:) = x;
            %shift so that x axis is close to energy level
            Nb_ref = Nb_ref';
        end

        %mapData = array containing the data and energy of all map files
        %mapData(i,j,k,l)
        %i is the file number
        %j = 1 is the map data, j = 2 is the energy
        %k and l are the 2D array of map data
        function [mapData, energies]= loadAllMapData(folderName)
            %open the folder
            Files=dir(folderName);
            %skip the first two entires because they are . and ..
            for k=3:length(Files)
                %get the current file name
                FileName=Files(k).name;
                %read the data of that file
                [data, energy] = XraySpecFunctions.readMapFile(FileName);
                %write it output arrays
                mapData(:,:,k-2) = data;
                energies(k-2) = energy;
            end
        end

        function out = system_solver(mapData,metal_ref,NbSi2_ref,Nb2O5_ref,NbO2_ref,NbO_ref)
            %mapData(k,l,i)
            %i is the file number
            %k and l are the 2D array of map data
                cols = length(mapData(1,:,1));
                rows = length(mapData(:,1,1));
                out = zeros([rows cols 5]);
                %iterate pixel by pixel
                for k = 1:1:rows
                    for l = 1:1:cols
                        %change and compare maps 1 and 2
                        stepDiff = mapData(k,l,18)-mapData(k,l,2);
                        %that the percentages should add up to that number
                        %create variables to solve for
                        for i = 1:length(metal_ref)
                        pixelArray(i) = mapData(k,l,i);
                        end
                        func = @(x) [pixelArray'-x(1).*metal_ref(:,2)-x(2).*NbSi2_ref(:,2)-x(3).*Nb2O5_ref(:,2)-x(4).*NbO2_ref(:,2)-x(5).*NbO_ref(:,2); 1-x(1)-x(2)-x(3)-x(4)-x(5)];
                        opts = optimoptions("lsqnonlin",'display','off');
                        problem = createOptimProblem('lsqnonlin','x0',[0 0 0 0 0],'lb',[0 0 0 0 0],'ub',[1 1 1 1 1],'objective',func,'options',opts);
                        %output step difference with everything else
                        [x, resnorm]= lsqnonlin(problem);
                        out(k,l,1) = x(1);
                        out(k,l,2) = x(2);
                        out(k,l,3) = x(3);
                        out(k,l,4) = x(4);
                        out(k,l,5) = x(5);
                        out(k,l,6) = resnorm;
                        out(k,l,7) = stepDiff;
                    end
                end
        end
        
        %out = array of elements with energies matching the mapData
        %energies
        %ref = reference spectrum array containing energies and intensities
        function out = create_referenceArray(energies,ref)
            %iterate through mapData energy level
            for i = 1:length(energies)
                %find the closest energy in the reference array
                closest = interp1(ref(:,1),ref(:,1),energies(i),'nearest');
                diff = energies(i)-closest;
                if diff>0 % difference is positive so closest is smaller than data
                    %energy
                    energyLow = ref(ref(:,1)==closest,1);
                    %intensity
                    intensityLow = ref(ref(:,1)==closest,2);
                    %energy
                    energyHigh = ref(find(ref == energyLow)+1,1);
                    %intensity
                    intensityHigh = ref(find(ref == energyLow)+1,2);
                    %take weighted average between high and low and assign
                    %value
                    weight = 1-(abs(diff)/(energyHigh-energyLow));
                    out(i,1) = (weight*energyLow+(1-weight)*energyHigh);
                    out(i,2) = (weight*intensityLow+(1-weight)*intensityHigh);
                elseif diff<0 %difference is negative so closest is larger than data
                    %energy
                    energyHigh = ref(ref(:,1)==closest,1);
                    %intensity
                    intensityHigh = ref(ref(:,1)==closest,2);
                    %energy
                    energyLow = ref(find(ref == energyHigh)-1,1);
                    %intensity
                    intensityLow = ref(find(ref == energyHigh)-1,2);
                    weight = 1-(abs(diff)/(energyHigh-energyLow));
                    out(i,1) = (weight*energyHigh+(1-weight)*energyLow);
                    out(i,2) = (weight*intensityHigh+(1-weight)*intensityLow);
                elseif diff==0 %difference is 0 so closest is the same energy value
                    %energy
                    out(i,1) = ref(ref(:,1)==closest,1);
                    %intensity
                    out(i,2) = ref(ref(:,1)==closest,2);
                end
            end
        end

        %shift = amount energy values are shifted
        %metal_ref = Nb metal reference spectrum
        %Nb2O5_ref = Nb2O5 oxide reference spectrum
        %NbO2_ref = NbO2 oxide reference spectrum
        %NbO_ref = NbO oxide reference spectrum
        %og_shift = 3D array containing the percentages for each pixel using the
        %provided shift
        %lower_shift = 3D array containing the percentages for each pixel using a
        %lower shift value
        %upper_shift = 3D array containing the percentages for each pixel using a
        %higher shift value
        function [og_shift] = xray_mapAnalysis(folder,map_shift,metal_ref,metal_shift,NbSi2_ref,NbSi2_shift,Nb2O5_ref,Nb2O5_shift,NbO2_ref,NbO2_shift,NbO_ref,NbO_shift)
            %load the data of all map files
            disp("loading map data")
            [mapData, mapEnergies]= XraySpecFunctions.loadAllMapData(folder);
            %load reference spectra
            if isstring(metal_ref)
                metal_ref_spectra = XraySpecFunctions.readSpectraFile(metal_ref);
                metal_ref_spectra(:,1) = metal_ref_spectra(:,1)+metal_shift;
            else
                metal_ref_spectra = metal_ref;
                metal_ref_spectra(:,1) = metal_ref_spectra(:,1)+metal_shift;
            end
            NbSi2_ref_spectra = XraySpecFunctions.readSpectraFile(NbSi2_ref);
            NbSi2_ref_spectra(:,1) = NbSi2_ref_spectra(:,1)+NbSi2_shift;
            Nb2O5_ref_spectra = XraySpecFunctions.readSpectraFile(Nb2O5_ref);
            Nb2O5_ref_spectra(:,1) = Nb2O5_ref_spectra(:,1)+Nb2O5_shift;
            NbO2_ref_spectra = XraySpecFunctions.readSpectraFile(NbO2_ref);
            NbO2_ref_spectra(:,1) = NbO2_ref_spectra(:,1)+NbO2_shift;
            NbO_ref_spectra = XraySpecFunctions.readSpectraFile(NbO_ref);
            NbO_ref_spectra(:,1) = NbO_ref_spectra(:,1)+NbO_shift;
            %shift reference spectra
            %shift the energy of all maps
            mapEnergies(:) = mapEnergies(:)+map_shift;
            %normalize map data
            mapData = XraySpecFunctions.noramalizeMaps(mapData);
            %create array for each reference containing the intensity at shifted energy
            %levels
            disp("creating reference arrays")
            metal_ref_array = XraySpecFunctions.create_referenceArray(mapEnergies,metal_ref_spectra);
            NbSi2_ref_array = XraySpecFunctions.create_referenceArray(mapEnergies,NbSi2_ref_spectra);
            Nb2O5_ref_array = XraySpecFunctions.create_referenceArray(mapEnergies,Nb2O5_ref_spectra);
            NbO2_ref_array = XraySpecFunctions.create_referenceArray(mapEnergies,NbO2_ref_spectra);
            NbO_ref_array = XraySpecFunctions.create_referenceArray(mapEnergies,NbO_ref_spectra);
            %solve system of equation function call and save to og_shift
            disp("solving equations")
            og_shift = XraySpecFunctions.system_solver(mapData,metal_ref_array,NbSi2_ref_array,Nb2O5_ref_array,NbO2_ref_array,NbO_ref_array);
            for i = 1:length(mapEnergies)
                averages(i) = mean(mapData(:,:,i),[1 2]);
                energies(i) = mapEnergies(i);
            end
            %plot spectra
            figure
            hold on
            plot(energies,averages,'-o','LineWidth',2)
            plot(metal_ref_array(:,1),metal_ref_array(:,2),'-o','LineWidth',2)
            plot(NbSi2_ref_array(:,1),NbSi2_ref_array(:,2),'-o','LineWidth',2)
            plot(Nb2O5_ref_array(:,1),Nb2O5_ref_array(:,2),'-o','LineWidth',2)
            plot(NbO2_ref_array(:,1),NbO2_ref_array(:,2),'-o','LineWidth',2)
            plot(NbO_ref_array(:,1),NbO_ref_array(:,2),'-o','LineWidth',2);
            xlim([2350 2390])
            legend(sprintf('mapData: %g eV',map_shift),sprintf('metal: %g eV',metal_shift),sprintf('NbSi2: %g eV',NbSi2_shift),sprintf('Nb2O5: %g eV',Nb2O5_shift),sprintf('NbO2: %g eV',NbO2_shift),sprintf('NbO: %g eV',NbO_shift))
            title("Spectra: "+map_shift+" eV")
            hold off
            %plot oxide maps
            Nb2O5_avg = mean(og_shift(:,:,3),[1 2]);
            NbO2_avg = mean(og_shift(:,:,4),[1 2]);
            NbO_avg = mean(og_shift(:,:,5),[1 2]);
            residual_avg = mean(og_shift(:,:,6),[1 2]);
            oxideSum = Nb2O5_avg+NbO2_avg+NbO_avg;
            Nb2O5 = Nb2O5_avg*100/oxideSum;
            NbO2 = NbO2_avg*100/oxideSum;
            NbO = NbO_avg*100/oxideSum;
            figure
            subplot(2,3,1)
            s = pcolor(og_shift(:,:,1).*100);
            s.FaceColor = 'interp';
            c = colorbar;  
            c.Ruler.TickLabelFormat='%g%%';
            title("Metal")
            subtitle("Shift: "+metal_shift+" eV")
            subplot(2,3,2)
            s = pcolor(og_shift(:,:,2).*100);
            s.FaceColor = 'interp';
            c = colorbar;  
            c.Ruler.TickLabelFormat='%g%%';
            title("NbSi2")
            subtitle("Shift: "+NbSi2_shift+" eV")
            subplot(2,3,3)
            s = pcolor(og_shift(:,:,3).*100);
            s.FaceColor = 'interp';
            c = colorbar;  
            c.Ruler.TickLabelFormat='%g%%';
            title("Nb2O5")
            subtitle(sprintf("Shift: %g eV      Percent of total oxide: %0.1f%%",Nb2O5_shift,Nb2O5))
            subplot(2,3,4)
            s = pcolor(og_shift(:,:,4).*100);
            s.FaceColor = 'interp';
            c = colorbar;  
            c.Ruler.TickLabelFormat='%g%%';
            title("NbO2")
            subtitle(sprintf("Shift: %g eV      Percent of total oxide: %0.1f%%",NbO2_shift,NbO2))
            subplot(2,3,5)
            s = pcolor(og_shift(:,:,5).*100);
            s.FaceColor = 'interp';
            c = colorbar;  
            c.Ruler.TickLabelFormat='%g%%';
            title("NbO")
            subtitle(sprintf("Shift: %g eV      Percent of total oxide: %0.1f%%",NbO_shift,NbO))
            sgtitle(sprintf('Percentages\n Data Shift: %g eV',map_shift))
            %plot residual map
            figure
            s = pcolor(og_shift(:,:,6));
            s.FaceColor = 'interp';
            colorbar;
            title("Residual Squared: "+map_shift+" eV")
            subtitle("Avg: "+ residual_avg)

            %plot oxide maps*step difference
            figure
            subplot(2,3,1)
            s = pcolor(og_shift(:,:,1).*og_shift(:,:,7));
            s.FaceColor = 'interp';
            colorbar;
            title("Metal")
            subtitle("Shift: "+metal_shift+" eV")
            subplot(2,3,2)
            s = pcolor(og_shift(:,:,2).*og_shift(:,:,7));
            s.FaceColor = 'interp';
            colorbar;
            title("NbSi2")
            subtitle("Shift: "+NbSi2_shift+" eV")
            subplot(2,3,3)
            s = pcolor(og_shift(:,:,3).*og_shift(:,:,7));
            s.FaceColor = 'interp';
            colorbar;
            title("Nb2O5")
            subtitle(sprintf("Shift: %g eV      Percent of total oxide: %0.1f%%",NbSi2_shift,Nb2O5))
            subplot(2,3,4)
            s = pcolor(og_shift(:,:,4).*og_shift(:,:,7));
            s.FaceColor = 'interp';
            colorbar;
            title("NbO2")
            subtitle(sprintf("Shift: %g eV      Percent of total oxide: %0.1f%%",NbO2_shift,NbO2))
            subplot(2,3,5)
            s = pcolor(og_shift(:,:,5).*og_shift(:,:,7));
            s.FaceColor = 'interp';
            colorbar;
            title("NbO")
            subtitle(sprintf("Shift: %g eV      Percent of total oxide: %0.1f%%",NbO_shift,NbO))
            sgtitle(sprintf('Percentage*Step Height\n Data Shift: %g eV',map_shift))
            subplot(2,3,6)
            s = pcolor(og_shift(:,:,7));
            s.FaceColor = 'interp';
            colorbar;
            title("Step Difference")
        end

        %passing mapData and mapEnergies so they only needed to be loaded
        %one time instead of every optimization run
        function [Nb2O5,NbO2,NbO,residual_avg,lowRegionAvg] = xray_percentAnalysis(mapData,mapEnergies,map_shift,metal_ref,metal_shift,NbSi2_ref,NbSi2_shift,Nb2O5_ref,Nb2O5_shift,NbO2_ref,NbO2_shift,NbO_ref,NbO_shift)
            %load reference spectra
            if isstring(metal_ref)
                metal_ref_spectra = XraySpecFunctions.readSpectraFile(metal_ref);
                metal_ref_spectra(:,1) = metal_ref_spectra(:,1)+metal_shift;
            else
                metal_ref_spectra = metal_ref;
                metal_ref_spectra(:,1) = metal_ref_spectra(:,1)+metal_shift;
            end
            NbSi2_ref_spectra = XraySpecFunctions.readSpectraFile(NbSi2_ref);
            NbSi2_ref_spectra(:,1) = NbSi2_ref_spectra(:,1)+NbSi2_shift;
            Nb2O5_ref_spectra = XraySpecFunctions.readSpectraFile(Nb2O5_ref);
            Nb2O5_ref_spectra(:,1) = Nb2O5_ref_spectra(:,1)+Nb2O5_shift;
            NbO2_ref_spectra = XraySpecFunctions.readSpectraFile(NbO2_ref);
            NbO2_ref_spectra(:,1) = NbO2_ref_spectra(:,1)+NbO2_shift;
            NbO_ref_spectra = XraySpecFunctions.readSpectraFile(NbO_ref);
            NbO_ref_spectra(:,1) = NbO_ref_spectra(:,1)+NbO_shift;
            %shift reference spectra
            %shift the energy of all maps
            mapEnergies(:) = mapEnergies(:)+map_shift;
            %normalize map data
            mapData = XraySpecFunctions.noramalizeMaps(mapData);
            %create array for each reference containing the intensity at shifted energy
            %levels
            metal_ref_array = XraySpecFunctions.create_referenceArray(mapEnergies,metal_ref_spectra);
            NbSi2_ref_array = XraySpecFunctions.create_referenceArray(mapEnergies,NbSi2_ref_spectra);
            Nb2O5_ref_array = XraySpecFunctions.create_referenceArray(mapEnergies,Nb2O5_ref_spectra);
            NbO2_ref_array = XraySpecFunctions.create_referenceArray(mapEnergies,NbO2_ref_spectra);
            NbO_ref_array = XraySpecFunctions.create_referenceArray(mapEnergies,NbO_ref_spectra);
            %solve system of equation function call and save to og_shift
            og_shift = XraySpecFunctions.system_solver(mapData,metal_ref_array,NbSi2_ref_array,Nb2O5_ref_array,NbO2_ref_array,NbO_ref_array);
            %pick spots above below and along curve and take the average
            %and output
            %also output average of left side
            Nb2O5_avg = mean(og_shift(:,:,3).*og_shift(:,:,7),[1 2]);
            NbO2_avg = mean(og_shift(:,:,4).*og_shift(:,:,7),[1 2]);
            NbO_avg = mean(og_shift(:,:,5).*og_shift(:,:,7),[1 2]);
            residual_avg = mean(og_shift(:,:,6),[1 2]);
            oxideSum = Nb2O5_avg+NbO2_avg+NbO_avg;
            Nb2O5 = Nb2O5_avg*100/oxideSum;
            NbO2 = NbO2_avg*100/oxideSum;
            NbO = NbO_avg*100/oxideSum;
            lowRegionAvg = (og_shift(38,44,1).*og_shift(38,44,7)+og_shift(45,28,1).*og_shift(45,28,7)+og_shift(48,66,1).*og_shift(48,66,7)+og_shift(55,53,1).*og_shift(55,53,7)+og_shift(56,35,1).*og_shift(56,35,7)+og_shift(78,71,1).*og_shift(78,71,7)+og_shift(78,58,1).*og_shift(78,58,7)+og_shift(78,32,1).*og_shift(78,32,7)+og_shift(78,19,1).*og_shift(78,19,7))/9;
        end
        
        %mu = mean
        %sig = variance
        %amp = amplitude
        %x = x axis
        function out = myGauss(x,mu,sig,amp)
            out = amp*exp(-(((x-mu).^2)/(2*sig.^2)));
        end
        
        %function to read spectra and energy data from file provided
        %left column of data is energy and right column is spectra data
        function data = readSpectraFile(fileName)
            file = fopen(fileName,'r');
            i = 1;
            %read entire file until we reach the end and save each line to data array
            while ~feof(file)
                line = fgets(file);
                data(i,:) = str2double(split(line));
                i = i+1;
            end
            %remove last column
            data(:,3) = [];
            %close the file
            fclose(file);
        end
        
        %function to read intensity map data and energy level of file provided
        function [data,energy] = readMapFile(fileName)
            %open file in read mode
            file = fopen(fileName,'r');
            %read first 15 lines of header information and don't save it
            for i = 1:15
                line = fgets(file);
            end
            %read line with enegy level and extract it
            line = fgets(file);
            energy = split(line);
            energy = str2double(energy(3));
            %read down 14 more lines
            for i = 1:14
                line = fgets(file);
            end
            %read first line of data
            line = fgets(file);
            data(1,:) = str2double(split(line));
            i = 2;
            %read entire file until we reach the end and save each line to data array
            while ~feof(file)
                line = fgets(file);
                data(i,:) = str2double(split(line));
                i = i+1;
            end
            %remove last two columns
            data(:,size(data,2)-1:size(data,2)) = [];
            %narrow the data down to just the chunk that is around 12000s
            %data = data(81:160,1:93);
            %narrow data to the 30s chunk
            data = data(321:400,1:93);
            %close the file
            fclose(file);
        end
        
        %function that calculates the average value for the entire file
        function average = fileAverage(data)
            total = 0;
            %number of rows
            rows = length(data(1,:));
            %number of columns
            cols = length(data(:,1));
            %add all elements together
            for i = 1:1:rows
                for j = 1:1:cols
                    total = total + data(i,j);
                end
            end
            %calculate average of entire file
            average = total/(rows*cols);
        end
        
        %function that calculates the average of a spot given the coordinates of
        %corners
        %coordinates format is an array where the first number is the row position
        %and the second number is the column position
        %for example the first element in the first columnn would be [1,1]
        function average = spotAverage(data,topLeftCorner,bottomLeftCorner,topRightCorner)
            %verify coordinates are within bounds of array?
            total = 0;
            numElements = 0;
            %add all elements together
            for i = topLeftCorner(1):1:bottomLeftCorner(1)
                for j = topLeftCorner(2):1:topRightCorner(2)
                    total = total + data(i,j);
                    numElements = numElements + 1;
                end
            end
            %calculate average
            average = total/(numElements);
        end

        %finds energy, average, minimum, maximum, and standard deviation of
        %the 12000 chunk of the provided file and writes it to a text file
        function statsOfData(fileName)
            [data,energy] = XraySpecFunctions.readMapFile(fileName);
            data1 = data(81:160,1:93);
            avg = mean(data1,"all");
            minimum = min(data1,[],"all");
            maximum = max(data1,[],"all");
            dev = std(data1,0,"all");
            T = table(energy,avg, minimum, maximum, dev);
            dataName = split(fileName,"_");
            dataName = split(dataName(4),".");
            name = dataName(1)+'_stats.txt';
            %needs a heading to write out
            writetable(T,name,'WriteRowNames',true);
        end
        
        %normalizes mapData
        %subtracts average of first map from everything
        %divides average of last map from everything
        function mapDataOut = noramalizeMaps(mapData)
            %mapData(i,j,k,l)
            %i is the file number
            %j = 1 is the map data, j = 2 is the energy
            %k and l are the 2D array of map data
            %find average of first map
            firstAvg = mean(mapData(:,:,1),[1 2]);
            %loop until first avg is 0
            while round(firstAvg) ~= 0
                %subtract first avg from everything
                mapData(:,:,1:18) = mapData(:,:,1:18)-firstAvg;
                %recalculate first avg
                firstAvg = mean(mapData(:,:,1),[1 2]);
            end
            %find average of last map
            %adjust last average so that we only average the section is
            %metal
            lastAvg = mean(mapData(1:30,:,18),[1 2]);
            %multiply all maps by 1/lastAvg
            %loop until last average is 1?
            mapData(:,:,1:18) = mapData(:,:,1:18).*(1/lastAvg);
            mapDataOut = mapData;
        end
    end
end