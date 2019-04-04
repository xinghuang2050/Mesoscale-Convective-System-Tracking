function tracks = updateAssignedTracks(assignments, tracking_method, tracks, list_component, timeStamp)
    numAssignedTracks = size(assignments, 1);
    for i = 1:numAssignedTracks
        trackIdx = assignments(i, 1);
        detectionIdx = assignments(i, 2);
        %centroid = [list_component(detectionIdx).x, list_component(detectionIdx).y];
        if strcmpi(tracking_method,'overlapping')
            centroid = [list_component(detectionIdx).x_shield,list_component(detectionIdx).y_shield];
        elseif strcmpi(tracking_method,'trajectory') || strcmpi(tracking_method,'TO')
            centroid = [list_component(detectionIdx).x,list_component(detectionIdx).y];
        end

        % Correct the estimate of the object's location
        % using the new detection.
        correct(tracks(trackIdx).kalmanFilter, centroid);

        % Replace predicted position with detected position
        tracks(trackIdx).x = centroid(1);
        tracks(trackIdx).y = centroid(2);

        % Update track's age.
        tracks(trackIdx).age = tracks(trackIdx).age + 1;
        % Record the informations
        tracks(trackIdx).list_core_x(tracks(trackIdx).age) = list_component(detectionIdx).x;
        tracks(trackIdx).list_core_y(tracks(trackIdx).age) = list_component(detectionIdx).y;
        tracks(trackIdx).list_shield_x(tracks(trackIdx).age) = list_component(detectionIdx).x_shield;
        tracks(trackIdx).list_shield_y(tracks(trackIdx).age) = list_component(detectionIdx).y_shield;

        tracks(trackIdx).list_shield(tracks(trackIdx).age) = list_component(detectionIdx).shield;
        tracks(trackIdx).list_core(tracks(trackIdx).age) = list_component(detectionIdx).core;

        tracks(trackIdx).list_time(tracks(trackIdx).age) = timeStamp;
        tracks(trackIdx).list_pixel{tracks(trackIdx).age} = list_component(detectionIdx).pixels;
        tracks(trackIdx).list_temperature{tracks(trackIdx).age} = list_component(detectionIdx).temperature;
        tracks(trackIdx).list_low_temperature(tracks(trackIdx).age) = list_component(detectionIdx).low_temperature;
        tracks(trackIdx).list_avg_temperature(tracks(trackIdx).age) = mean(list_component(detectionIdx).temperature);
        tracks(trackIdx).consective_invisible_count = 0;
    end
end
