function [I_cr] = TrackWorms()
prompts = {'Min Size','Max Size','Background Probability','Min Run Length','Motion Threshold'};
prompts = inputdlg(prompts);
MinSize = str2double(prompts{1});
MaxSize = str2double(prompts{2});
bkgProb = str2double(prompts{3});
MinRun = str2double(prompts{4});
MotionThresh = str2double(prompts{5});
vidDir = uigetdir;
vidFiles = dir(vidDir);
I_cr = [];
names = {};
rois = struct('roi',[]);
for k = 1:length(vidFiles) - 2
    v = VideoReader([vidDir filesep vidFiles(k+2).name]);
    f = read(v,1);
    imshow(imadjustn((f)));
    xlabel('Circle tracking region then press enter')
    h = drawellipse;
    pause
    h = poly2mask(h.Vertices(:,1),h.Vertices(:,2),v.Height,v.Width);
    rois(k).roi = h;
    clear("v")
end
for i = 1:length(vidFiles) - 2
    vid = [vidDir filesep vidFiles(i+2).name];
    [allTracks,fileName,obj] = motionTracking(MinSize,MaxSize,bkgProb,MotionThresh,vid,rois(i).roi);
    allTracks = analyzeTracks(allTracks,MotionThresh,obj);
    saveas(gcf,[vidDir filesep fileName '.fig'])

    %  other possible ways to calc I_cr, the chosen way is from the old
    %  scripts:
    %duration of runs exceeding 16px in length in warm vs cold direction
    %  disp('I_cr')
    %  (sum(cat(1,allTracks.dX) > 0) - sum(cat(1,allTracks.dX) < 0))/(sum(cat(1,allTracks.dX) > 0) + sum(cat(1,allTracks.dX) < 0))
    %  disp('I_cr of means')
    %  (mean([allTracks(:).coldRunDuration]) - mean([allTracks(:).warmRunDuration]))/(mean([allTracks(:).warmRunDuration allTracks(:).coldRunDuration]))
    %  disp('I_cr tracks toward cold')
    %  tC = [];
    %  for i=1:length(allTracks);tC(end+1) = allTracks(i).centroids(end,1) - allTracks(i).centroids(1,1);end
    %  (sum(tC < 0) - sum(tC > 0))/(length(tC))
    %  disp('I_cr old scripts?')
    

    %remove non moving tracks
    allTracks = allTracks(~([allTracks(:).total_dX] < 6));
    runs = cat(1,allTracks.indvRuns);
    runs = runs(abs(runs(:,1)) >= MinRun,:);
    %display I_cr calculated as duration of all runs (greater than length ==
    %MotionThresh) (towards cold - warm)/(cold + warm)

    [fileName ' ' 'I_cr: ' num2str((sum(runs(runs(:,2) > 0,2)) - sum(abs(runs(runs(:,2)<0,2))))/sum(abs(runs(:,2))))]
    I_cr(end+1) = (sum(runs(runs(:,2) > 0,2)) - sum(abs(runs(runs(:,2)<0,2))))/sum(abs(runs(:,2)));
    names{end+1} = fileName;
end
names = names';
I_cr = I_cr';
writetable(table(names,I_cr),[vidDir filesep 'analysis' '.csv']);
end
