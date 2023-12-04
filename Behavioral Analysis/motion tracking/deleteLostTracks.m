
        if isempty(tracks)
            return;
        end

        invisibleForTooLong = 20;
        ageThreshold = 10;

        % Compute the fraction of the track's age for which it was visible.
        ages = [tracks(:).age];
        totalVisibleCounts = [tracks(:).totalVisibleCount];
        visibility = totalVisibleCounts ./ ages;
        visAge = totalVisibleCounts./(ages - invisibleForTooLong);
        % Find the indices of 'lost' tracks.
        lostInds = (ages < ageThreshold & visibility < 0.6) | ...
            [tracks(:).consecutiveInvisibleCount] >= invisibleForTooLong | ...
            (totalVisibleCounts - ages) >= 20;
        keepInds = ((ages >= ageThreshold & visAge >= 0.6) & [tracks(:).consecutiveInvisibleCount] >= invisibleForTooLong) | ...
            ((ages < ageThreshold & visAge >= 0.6) & [tracks(:).consecutiveInvisibleCount] >= invisibleForTooLong);

        % Delete lost tracks.
        if sum(keepInds) > 0
            keepTracks(end+1:end+sum(keepInds)) = tracks(keepInds);
        end
        tracks = tracks(~lostInds);
        