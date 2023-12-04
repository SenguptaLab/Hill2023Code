function [allTracks,fileName,obj] = motionTracking(MinSize,MaxSize,bkgProb,MotionThresh,vid,roi)
obj = setupSystemObjects(MinSize,MaxSize,bkgProb,vid);
fileName = obj.reader.Name;
[tracks,keepTracks] = initializeTracks(); % Create an empty array of tracks.
nextId = 1; % ID of the next track
% Detect moving objects, and track them across video frames.

%mask video


while hasFrame(obj.reader)
frame = readFrame(obj.reader);
frame = bsxfun(@times, frame, cast(roi,class(frame)));
detectObjects;
predictNewLocationsOfTracks();
detectionToTrackAssignment;
updateAssignedTracks;
updateUnassignedTracks;
deleteLostTracks;
createNewTracks;
allTracks = [keepTracks tracks];
displayTrackingResults;
end
