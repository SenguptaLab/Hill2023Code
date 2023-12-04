%To use after THexporttraces_xlsx.m in order to record maximum amplitudes
%of the dff files. Also important for making and updating sheetlist
%variable for legend/options box

prompt='How many traces?';
blank=input(prompt); %decide how many traces you want to analyze (1-4)
sheetlist=string(sheets); %makes sheetlist into strings to use in legend

if blank >=1 %variable for how many traces
    Trace1=menu('Choose the first one to plot',sheetlist); %choose which data set to use
    dff_A=readmatrix(filename + "_dff.xlsx",'Sheet',Trace1); %read selected spreadsheet into matrix
    dff_Alength=length(dff_A); %length of matrix
    prompt=sprintf('You got %d frames, how many to plot?',dff_Alength); %let user know how many frames you have
    length1 = input(prompt); %input of how many frames of the dff files do you want to grab
    if isempty(length1)
        length1 = dff_Alength;
    end
    leg1=sheetlist(Trace1); %record name of sheet
end

if blank >=2

    Trace2=menu('Choose the second one to plot',sheetlist); %choose which spreadsheet to use
    dff_B=readmatrix(filename + "_dff.xlsx",'Sheet',Trace2); %read selected spreadsheet into matrix
    dff_Blength=length(dff_B);  %length of matrix
    prompt=sprintf('You got %d frames, how many to plot?',dff_Blength); %let user know how many frames you have
    length2 = input(prompt); %input of how many frames of the dff files do you want to grab
    if isempty(length2)
        length2 = dff_Blength;
    end
    leg2=sheetlist(Trace2);  %record name of sheet
end

if blank >=3

    Trace3=menu('Choose the third one to plot',sheetlist); %choose which spreadsheet to use
    dff_C=readmatrix(filename + "_dff.xlsx",'Sheet',Trace3); %read selected spreadsheet into matrix
    dff_Clength=length(dff_C);  %length of matrix
    prompt=sprintf('You got %d frames, how many to plot?',dff_Clength); %let user know how many frames you have
    length3 = input(prompt); %input of how many frames of the dff files do you want to grab
    if isempty(length3)
        length3 = dff_Clength;
    end
    leg3=sheetlist(Trace3);  %record name of sheet
end

if blank >=4

    Trace4=menu('Choose the fourth one to plot',sheetlist); %choose which spreadsheet to use
    dff_D=readmatrix(filename + "_dff.xlsx",'Sheet',Trace4); %read selected spreadsheet into matrix
    dff_Dlength=length(dff_D);  %length of matrix
    prompt=sprintf('You got %d frames, how many to plot?',dff_Dlength); %let user know how many frames you have
    length4 = input(prompt); %input of how many frames of the dff files do you want to grab
    if isempty(length4)
        length4 = dff_Dlength;
    end
    leg4=sheetlist(Trace4);  %record name of sheet
end

%brings up a plot of all the traces of each data set, asks you to click a 
%point to start counting for min/max calcs

if blank >=1 %how many you are plotting
    plot(dff_A) %brings up a plot of the dff traces
    title('click the min! Do it now!') %text on top of graph
    Astrt=round(ginput(1)); %records where you clicked
    close 
end

if blank >=2
    plot(dff_B)
    title('click the min! Do it now!')
    Bstrt=round(ginput(1));
    close
end

if blank >=3
    plot(dff_C)
    title('click the min! Do it now!')
    Cstrt=round(ginput(1));
    close
end

if blank >=4
    plot(dff_D)
    title('click the min! Do it now!')
    Dstrt=round(ginput(1));
    close
end

%takes the min and max after the point you clicked, subtracts to make
%amplitude
if blank >=1 %how many you're analyzing
    Amin=min(dff_A(Astrt:dff_Alength,:)); %takes minimum of each trace starting from where you clicked
    Amax=max(dff_A(Astrt:dff_Alength,:)); %takes maximum of each trace starting from where you clicked
    Aamp=Amax-Amin; %finds amplitude by subtracting minimum from maximum
end

if blank >=2
    Bmin=min(dff_B(Bstrt:dff_Blength,:));
    Bmax=max(dff_B(Bstrt:dff_Blength,:));
    Bamp=Bmax-Bmin;
end

if blank >=3
    Cmin=min(dff_C(Cstrt:dff_Clength,:));
    Cmax=max(dff_C(Cstrt:dff_Clength,:));
    Camp=Cmax-Cmin;
end

if blank >=4
    Dmin=min(dff_D(Dstrt:dff_Dlength,:));
    Dmax=max(dff_D(Dstrt:dff_Dlength,:));
    Damp=Dmax-Dmin;
end

%writes the amplitudes into a spreadsheet, with the same names as the
%original spreadsheet

if blank >=1
    writematrix(Amax',filename + "_dffmax.xlsx",'Sheet',leg1,'Range','A1') %writes amplitudes into a spreadsheet
end
if blank >=2
    writematrix(Bmax',filename + "_dffmax.xlsx",'Sheet',leg2,'Range','A1')
end
if blank >=3
    writematrix(Cmax',filename + "_dffmax.xlsx",'Sheet',leg3,'Range','A1')
end
if blank >=4
    writematrix(Dmax',filename + "_dffmax.xlsx",'Sheet',leg4,'Range','A1')
end

%Groups all of the amps for one data set into a single sheet for easy copy
%pasting

if blank >=1
    writematrix(Amax',filename + "_dffmax.xlsx",'Sheet',leg1 + "group",'Range','A1')
end
if blank >=2
    writematrix(Bmax',filename + "_dffmax.xlsx",'Sheet',leg1 + "group",'Range','B1')
end

if blank >=3
    writematrix(Cmax',filename + "_dffmax.xlsx",'Sheet',leg1 + "group",'Range','C1')
end
if blank >=4
    writematrix(Dmax',filename + "_dffmax.xlsx",'Sheet',leg1 + "group",'Range','D1')
end


save(filename) %Saves the matlab file


