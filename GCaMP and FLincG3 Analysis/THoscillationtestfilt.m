%counts peaks of dff traces. Run after exporttraces_TH and
%GCaMP_ampsdff_TH. Peaknum is peaks output


clear pktimes
clear pks
clear peaknum
clear peakfreq

Trace1=menu('Choose the first one to plot',sheetlist); %choose which spreadsheet to use
    dff_A=readmatrix(filename + "_dff.xlsx",'Sheet',Trace1); %read selected spreadsheet into matrix
   

sizetraces=size(dff_A); 
numtraces=sizetraces(2); %records length of matrix

for i=1:numtraces %for every trace in spreadsheet you chose...
 peakthresh=max(dff_A(:,i))*0.25; %for findpeaks, threshold peak prominence by a value 25% of the maximum F/F0
 [pks,pktimes]=findpeaks(lowpass(dff_A(:,i), 0.1, 1),'MinPeakProminence', peakthresh); %apply lowpass filter to trace, find peaks
 peaknum(i)=length(pktimes); %Number of peaks in each trace
 peakfreq(i)=mean(diff(pktimes)); %average distance between peaks in each trace (unused)
end

