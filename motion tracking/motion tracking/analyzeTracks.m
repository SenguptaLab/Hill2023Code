function allTracks_analyzed = analyzeTracks(allTracks,MotionThresh,obj)
figure
for i = 1:length(allTracks)
    %calc change in X coordinate between frames
    X = allTracks(i).centroids(:,1);
    dX = zeros(length(X),1);
    dX(2:end) = X(1:end-1);
    dX = dX - X;
    dX = dX(2:end);

    %remove frames when worm is still/not moving decisively in either X
    %direction and filter large changes in position (too large to be
    %possible)
    dX = dX(abs(dX) < 6 & abs(dX) > MotionThresh);
    dX_real = dX;
    allTracks(i).dX = dX;
    allTracks(i).total_dX = sum(abs(dX));

    %binarize for downstrem 1: moving towards cold, 0: moving towards warm
    dX(dX > 0) = 1;
    dX(dX < 0) = 0;
    %each frame is a second so the sum of the binarized X motion = duration
    allTracks(i).coldRunDuration = sum(dX);
    allTracks(i).warmRunDuration = sum(dX == 0);
    
    %find indices of changes in direction
    %set turns to 0 for tracks with no direction change
    if sum(dX) == length(dX)
        allTracks(i).turns = 0;
    elseif sum(dX) == 0
        allTracks(i).turns = 0;
    else        
        ddX = [0 ; dX(1:end-1)] - dX;
        turnIdx = find(ddX(2:end) ~= 0) + 1;
        allTracks(i).turns = turnIdx;     
    end

    %record length/duratiuon of each run within each track
    indvRuns = []; 
    %if there are no turns, movement was in a single direction. the length
    %duration of the run is set to that movement.
    if allTracks(i).turns == 0
        cold_warm = [allTracks(i).coldRunDuration -allTracks(i).warmRunDuration];
        [~,idx] = max(abs(cold_warm));
        if abs(cold_warm(idx)) >= 0
                indvRuns = [allTracks(i).total_dX cold_warm(idx)];
        end 
    else
        %if there are direction changes in the tracks determine the length
        %and duration of movement between each change
        for j=1:length(allTracks(i).turns)+1
            if j == 1
                run = dX_real(1:turnIdx(j)-1);
            elseif j == length(allTracks(i).turns)+1
                run = dX_real(turnIdx(end):length(dX_real));
            else
                run = dX_real(turnIdx(j-1):turnIdx(j)-1);

            end
            %record runs towards cold as positive and warm runs as negative
            if sum(run) > 0
                indvRuns(j,:) = [sum(run) length(run)];
            elseif sum(run) < 0
                indvRuns(j,:) = [-sum(run) -length(run)];
            end

        end

    end
    allTracks(i).indvRuns = indvRuns;
    allTracks_analyzed = allTracks;
    
    %make a plot of all tracks with each track's starting position set to 0
    plot(allTracks(i).centroids(:,1)-allTracks(i).centroids(1,1),-(allTracks(i).centroids(:,2)-allTracks(i).centroids(1,2)))
    axis([-(obj.reader.Height/2), obj.reader.Height/2, -(obj.reader.Width/2), obj.reader.Width/2])
    ax = axis();
    plot([0 0], [ax(3) ax(4)],'-k','LineWidth',2)
    hold on
end
