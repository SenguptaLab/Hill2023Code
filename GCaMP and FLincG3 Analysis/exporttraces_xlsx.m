clear
s=1;
while ~isequal(s,0)
    fn = 1;
    GC=[];
    c=1; %counter
    oldFolder=pwd; %records your active folder
    prompt = 'How long is your experiment(in frames)?';
    exp_length = input(prompt); %input of how many frames of the dff files do you want to grab
    disp('select folder containing analysis files, then click file. Click cancel when done');
    path=uigetdir;  %choose which folder you want to grab analysis file out of
    
    while ~isequal(path,0)
        
        cd(path) %goes to the folder you chose first
        [fn,path]=uigetfile([ '*.mat']); %gets file name (fn) and path to file name(path)
        load(fn,'raw'); %loads raw traces from file
        load(fn,'dff'); %loads f/f0 traces from file
        load(fn,'Temperature'); %loads raw temperature from file
        
        GC(c).raw=raw(1:exp_length,:); %saves raw traces to GC data structure
        GC(c).dff=dff(1:exp_length,:); %saves dff to GC data structure
        GC(c).temp=Temperature(1:exp_length); %saves raw temperature to data structure
        path=uigetdir; %choose which folder you want to grab analysis file out of
        c=c+1; %increases loop counter by one
        
    end % user clicked cancel and finished choosing files
    
    all_tracesraw = horzcat(GC.raw); %combines all the smoothed traces into one big matrix
    all_tracesdff = horzcat(GC.dff);
    all_temps = vertcat(GC.temp); %combines all the temperatures into one big matrix
    all_temps=all_temps'; %flips temps around
    
    cd(oldFolder) %goes back to original folder
    
    prompt = 'Enter the name of the spreadsheet, a new one will be created if it doesnt exist: ';
    filename=input(prompt,"s"); %creates or selects file you name
    
    prompt = 'Name of the sheet you want to enter the traces into? (existing or new):';
    TraceSheetInp=input(prompt, "s"); %creates or selects sheet you name
%     prompt = 'Into which cell do you want to insert the traces?';
%     cell=input(prompt, "s"); % Uncomment these two lines and comment the next to append data to existing sheet
    cell='A1';
    
    writematrix(all_tracesraw,filename + "_raw.xlsx",'Sheet',TraceSheetInp,'Range',cell) %Writes raw data to excel file
    writematrix(all_tracesdff,filename + "_dff.xlsx",'Sheet',TraceSheetInp,'Range',cell) %Writes dff data to excel file
   
    % % Can uncomment if you want to choose the name of the temperature
    % sheet
    %     prompt = 'Name of the sheet you want to enter the temp data into? (existing or new):';
    %     TempSheetInp=input(prompt, "s"); %creates or specifies sheet to add temp data to
    %     prompt = 'Into which cell do you want to insert the temperatures?';
    %     cell=input(prompt, "s"); %specifies which cell to input the data into
    
    writematrix(all_temps,filename + "_raw.xlsx",'Sheet',TraceSheetInp + "temps",'Range',cell) %writes temp data to file
    writematrix(all_temps,filename + "_dff.xlsx",'Sheet',TraceSheetInp + "temps",'Range',cell) %writes temp data to file
   
    [status,sheets,format] = xlsfinfo(filename + "_raw.xlsx"); %gets info from excel file, including sheet names
    sheets=sheets'; %flips sheets around so I can read it
    %[TotalDataRaw,TotalDataDff] = CopyAllData_xlsx(sheets,filename);
    save(filename) %saves as a matlab file
    clear GC %clears GC variable
    prompt = 'Press 1 to start over and 0 to end';
    s=input(prompt); %if s=0, ends loop, else starts everything over
    
  
end



