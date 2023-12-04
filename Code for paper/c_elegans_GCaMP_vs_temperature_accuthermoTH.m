%This script incorporates deltaF/F calculations from Jenna Sternberg and
%members of the Wyart lab, and temperature measurements from Harry Bell in
%the Sengupta lab.

clear all; close all
disp ('Choose image acquisition file')
[image folder] = uigetfile('*.*');
imagefile = strcat(folder, image);

disp ('Choose image to select ROIs')
[file2, folder2]= uigetfile('*.*');
StanDev = strcat(folder2, file2);

nframes = input('How many frames is the image file? ');
freq = input('What is the frequency of acquisition in Hz? ');
maxintensity = input('Choose maximum pixel intensity for display');
ROI_choice_frame = input('Choose frame to pick ROIs');
tempslope = input('temperature slope?'); 
tempint = input ('temperature intercept?');

M=multitiff2M_16bit(imagefile,1:nframes);
x_dim = length(M(1,:,1));
y_dim = length(M(:,1,1));

figure;I=imread(StanDev,ROI_choice_frame);imshow(I,[0,maxintensity]);set(gcf, 'Position', get(0, 'Screensize'));
disp('Choose left set of ROIs')
% call function getROIcell which allows user to select ROIs
rois = getROIcell;
close all
    
% generate mask from rois, calculate dff
if isempty(rois);
    dff = []
    raw = []
    Mask = []
    int = [];
end

for i=1:size(rois,2); 
    Mask{i} = roipoly(imread(imagefile),rois{i}(:,1),rois{i}(:,2));
end;

%function calc_dff_NH calculates delta F/F for chosen ROIs
[dff, raw] = calc_dff_NH(M, Mask, size(rois,2));

%top100 pixels version
%[dff, final] = calc_dff_NH_top100(M, Mask, size(rois,2));

%backgroundsub version:
%[dff_v, raw_v] = calc_dffNH_with_background_subtraction(M, Mask_v, size(rois_v,2));

% Generate png/fig for mask of rois
figure; imshow(I,[0,maxintensity]);
for i=1:length(rois);
    patch(rois{1,i}(:,1),rois{1,i}(:,2),'m','FaceAlpha',0.3);
    text(rois{1,i}(1,1),rois{1,i}(1,2),num2str(i),'Color','g');
    hold on;
end

title('ROIs','FontSize', 18);
rois = strcat(folder, 'ROIs');
saveas(gcf, rois,'fig'); 
saveas(gcf, rois,'png');
close

%need this for Harry's script
mypath = fullfile(folder);
fname = image;

%Opens the txt file from Accuthermo, extracts temp vs time
%txt file needs to have the same base name as tif file
accuthermo_file = readtable(strcat(mypath,fname(1:end-3),'dat'));

%Temperat = Lab_View_File(:,2);
Temperat = table2array(accuthermo_file(11:size(accuthermo_file),4));

Good_IND = [1:length(dff)];
Temperatureraw = interp1(1:length(Temperat),Temperat,Good_IND);
Temperature = (Temperatureraw*tempslope)+tempint;


Image_Time = length(dff);

%not sure why some of this is necessary
resampletemp = Temperature;
pathname = mypath;

average_trace = mean(dff,2);

%If you want to average temperature traces uncomment below
%average_T = mean(Temperature);

figure('position', [1200 0 700 1000]); hold on;
for i=1:size(dff,2)
    
    %subplot(size(rois,2),1,i);
    yyaxis left; ylim([min(dff(:)), (max(dff(:)))]); F_trace = plot(dff(:,i),'-k'); F_trace.Color(4)=0.3;
    plot(average_trace,'-k','LineWidth',2);
    ylabel('\deltaF/F (%)');
    yyaxis right; ylim([(min(Temperature)-1), (max(Temperature)+1)]); 
    plot(smooth(Temperature,20),'-g','LineWidth',2);
    %or use this for average-
    %yyaxis right; ylim([(min(average_T)-1), (max(average_T)+1)]); 
    %plot(average_T,'-g','LineWidth',2);
    ylabel('Temperature');
end

% Uncomment below for bounded line plotting 


delta_F = strcat(folder, 'delta_F');
saveas(gcf, delta_F,'fig');

pause(5);
close

save analysis

