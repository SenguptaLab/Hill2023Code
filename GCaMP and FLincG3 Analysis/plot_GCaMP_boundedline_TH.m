%for plotting averages of all dff traces in a condition as well as
%standard error shading
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
        length4 = dff_Dlength;
    end
    leg4=sheetlist(Trace4);  %record name of sheet
end

Tempvibes=menu('Choose where to take the temp from',sheetlist); %choose which sheet to take the temperatures from
Tempraw=readmatrix(filename + "_dff.xlsx",'Sheet',Tempvibes); %take temperatures from that sheet


%average the dffs
if blank >=1
    average_trace_A = mean(dff_A,2,'omitnan'); %Make the average trace of the dff matrix
    Maximum(1)=max(average_trace_A); 
    Minimum(1)=min(average_trace_A); %get min and max of average trace
end

if blank >=2
    average_trace_B = mean(dff_B,2,'omitnan');
    Maximum(2)=max(average_trace_B);
    Minimum(2)=min(average_trace_B);
end

if blank >=3
    average_trace_C = mean(dff_C,2,'omitnan');
    Maximum(3)=max(average_trace_C);
    Minimum(3)=min(average_trace_C);
end

if blank >=4
    average_trace_D = mean(dff_D,2,'omitnan');
    Maximum(4)=max(average_trace_D);
    Minimum(4)=min(average_trace_D);

end

real_temp_ramp=mean(Tempraw,2); %get mean of temp ramps

%get standard deviation at every frame
if blank >=1
    for i=1:length(dff_A)
        std_A(i) = std(dff_A(i,:),'omitnan');
    end
end
if blank >=2
    for i=1:length(dff_B)
        std_B(i) = std(dff_B(i,:),'omitnan');
    end
end

if blank >=3
    for i=1:length(dff_C)
        std_C(i) = std(dff_C(i,:),'omitnan');
    end
end
if blank >=4
    for i=1:length(dff_D)
        std_D(i) = std(dff_D(i,:),'omitnan');
    end
end

%calculate standard errors
if blank >=1
    sem_A = std_A/sqrt(size(dff_A,2));
end
if blank >=2
    sem_B = std_B/sqrt(size(dff_B,2));
end

if blank >=3
    sem_C = std_C/sqrt(size(dff_C,2));
end
if blank >=4
    sem_D = std_D/sqrt(size(dff_D,2));
end


%Using bounded line function for plotting all the average traces with SEMs 

figure('position', [1200 0 700 1000]); hold on; %make a blank figure
yyaxis left; ylim([(min(Minimum)-2), (max(Maximum)+4)]); %makes min and max y lims a little below and above min and max of average traces
ylabel('\deltaF/F (%)'); %Y-label

if blank >=1
    boundedline((1:length1),average_trace_A(1:length1),sem_A(1:length1),'k','alpha','transparency',.1); %Use function to make graph
end

if blank >=2
    boundedline((1:length2),average_trace_B(1:length2),sem_B(1:length2),'r','alpha','transparency',.1);
end

if blank >=3
    boundedline((1:length3),average_trace_C(1:length3),sem_C(1:length3),'b','alpha','transparency',.1);
end

if blank >=4
    boundedline((1:length4),average_trace_D(1:length4),sem_D(1:length4),'g','alpha','transparency',.1);
end

yyaxis right; ylim([(min(real_temp_ramp)-1), (max(real_temp_ramp)+1)]); %Make secondary Y axis for temperature
plot(real_temp_ramp(1:length1),'-g','LineWidth',2); %Details temperature line
ylabel('Temperature'); %puts Y-label on temp axis

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

