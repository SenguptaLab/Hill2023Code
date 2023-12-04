%for plotting averages of all dff traces in a condition as well as
%individual traces on the same graph
%requires https://www.mathworks.com/matlabcentral/fileexchange/27485-boundedline-m

%Use after THexporttraces_xlsx.m and THGCaMP_ampsdffsingle.m

prompt='How many traces?';
blank=input(prompt); %decide how many data sets you want to graph (1-4)

sheetlist=string(sheets); %makes sheetlist into strings to use in legend
% sheetlist=convertStringsToChars(sheetlist);
if blank >=1
    Trace1=menu('Choose the first one to plot',sheetlist); %choose which spreadsheet to use
    dff_A=readmatrix(filename + "_dff.xlsx",'Sheet',Trace1); %read selected spreadsheet into matrix
    dff_Alength=length(dff_A); %length of matrix
    prompt=sprintf('You got %d frames, how many to plot?',dff_Alength); %let user know how many frames you have
    length1 = input(prompt); %input of how many frames of the dff files do you want to grab
    if isempty(length1)
        length1 = dff_Alength; %Just press enter if the amount of frames it says is good
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
        length2 = dff_Blength; %Just press enter if the amount of frames it says is good
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
        length3 = dff_Clength; %Just press enter if the amount of frames it says is good
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
        length4 = dff_Dlength; %Just press enter if the amount of frames it says is good
    end
    leg4=sheetlist(Trace4);  %record name of sheet
end

Tempvibes=menu('Choose where to take the temp from',sheetlist); %choose which sheet to take the temperatures from
Tempraw=readmatrix(filename + "_dff.xlsx",'Sheet',Tempvibes); %take temperatures from that sheet


%average the dffs
if blank >=1
    average_trace_A = mean(dff_A,2,'omitnan'); %Make the average trace of the dff matrix
    Maximum(1)=max(dff_A,[],'all'); 
    Minimum(1)=min(dff_A,[],'all'); %get min and max of average trace
end

if blank >=2
    average_trace_B = mean(dff_B,2,'omitnan');
    Maximum(2)=max(dff_B,[],'all');
    Minimum(2)=min(dff_B,[],'all');
end

if blank >=3
    average_trace_C = mean(dff_C,2,'omitnan');
    Maximum(3)=max(dff_C,[],'all');
    Minimum(3)=min(dff_C,[],'all');
end

if blank >=4
    average_trace_D = mean(dff_D,2,'omitnan');
    Maximum(4)=max(dff_D,[],'all');
    Minimum(4)=min(dff_D,[],'all');

end

real_temp_ramp=mean(Tempraw,2); %get mean of temp ramps

% Actual code for plotting

figure('position', [1200 0 700 1000]); hold on; %creates blank figure
yyaxis left; ylim([(min(Minimum)-2), (max(Maximum)+4)]); %makes min and max y lims a little below and above min and max of all individual traces
ylabel('\deltaF/F (%)'); %adds y label

if blank >=1
plot(average_trace_A,'-','LineWidth',2, 'Color', [0 0.4470 0.7410]) %plot the average trace in a color
plot(dff_A,'-', 'Color',[0 0.4470 0.7410 0.8]) %plot each individual trace in the same color but a liitle transparent (4th number=percentage opacity)
end

if blank >=2
plot(average_trace_B,'-','LineWidth',2, 'Color', [0.8500 0.3250 0.0980])
plot(dff_B,'-', 'Color',[0.8500 0.3250 0.0980 0.8])
end

if blank >=3
plot(average_trace_C,'-','LineWidth',2, 'Color', [0.9290 0.6940 0.1250])
plot(dff_C,'-', 'Color',[0.9290 0.6940 0.1250 0.8])
end

if blank >=4
plot(average_trace_D,'-','LineWidth',2, 'Color', [0.4940 0.1840 0.5560])
plot(dff_D,'-', 'Color',[0.4940 0.1840 0.5560 0.8])
end

yyaxis right; ylim([(min(real_temp_ramp)-1), (max(real_temp_ramp)+1)]);
plot(real_temp_ramp(1:length1),'-g','LineWidth',2);
ylabel('Temperature');

%make a legend that has names of sheets, comment this
%section out if you don't need it

clear h
if blank >=1
    h(1)=plot(NaN,NaN,'k');
end

if blank >=2
    h(2)=plot(NaN,NaN,'r');
end

if blank >=3
    h(3)=plot(NaN,NaN,'b');
end

if blank >=4
    h(4)=plot(NaN,NaN,'g');
end

h(blank+1)=plot(NaN,NaN,'-g');

if blank ==1
    leggy=legend(h, 'k', '-g');

elseif blank ==2
    leggy=legend(h, 'k', 'r','-g');

elseif blank ==3
    leggy=legend(h, 'k', 'r', 'b','-g');

elseif blank ==4
    leggy=legend(h, 'k', 'r', 'b', 'g','-g');
end

if blank >=1
    leggy.String{1}=leg1;
end
if blank >=2
    leggy.String{2}=leg2;
end

if blank >=3
    leggy.String{3}=leg3;
end
if blank >=4
    leggy.String{4}=leg4;
end

leggy.String{blank+1}='Temperature';


% save your figure
prompt='Save figure as?'
figurename=input(prompt,"s"); % input filename of figure
save(filename) %save figure
saveas(gcf,figurename) %save figure as .fig file
saveas(gcf,figurename + ".png") %save figure as .png file
close