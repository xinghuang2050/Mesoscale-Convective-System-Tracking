function [tracks,...
        mcs_id_array,...
        record_tracks]...
    = deleteUnassignedTracks(unassignedTracks,...
                             tracking_method,...
                             tracks,...
                             core_area_threshold,...
                             age_threshold,...
                             mcs_id_array,...
                             record_tracks,...
                             record_begin_timestamp,...
                             record_end_timestamp,...
                             invisible_count_threshold)
    
    lostInds = zeros(1,length(tracks));
    for i=1:length(unassignedTracks)
        
        idx=unassignedTracks(i);
        
        if tracks(idx).consective_invisible_count <= invisible_count_threshold
            % save the temperally invisible tracks
            continue;
        else
            % otherwise, remove the track
            lostInds(idx) = 1;
        end
        
        track_begin_timestamp = tracks(idx).list_time(1);
        is_within_record_range = track_begin_timestamp >= record_begin_timestamp && ...
                                 track_begin_timestamp <= record_end_timestamp;
        if ~is_within_record_range
            % directly remove the track from tracks
            continue;
        end
        
        % correct the age counting.
        tracks(idx).age = tracks(idx).age - tracks(idx).consective_invisible_count;
        tracks(idx).list_time = tracks(idx).list_time(1:tracks(idx).age);
        tracks(idx).list_pixel = tracks(idx).list_pixel(1:tracks(idx).age);
        tracks(idx).list_temperature = tracks(idx).list_temperature(1:tracks(idx).age);
        
        if strcmpi(tracking_method,'overlapping')
            if tracks(idx).age >= age_threshold && max(tracks(idx).list_core) > core_area_threshold
                if tracks(idx).age >= age_threshold %&& min(tracks(idx).list_low_temperature)<218
                   tracks(idx).is_mcs=1;
                   mcs_id_array(end+1)=tracks(idx).id;
                   record_tracks(end+1)=tracks(idx);
                else
                    fprintf('error');
                end
            end
        elseif strcmpi(tracking_method,'trajectory') || strcmpi(tracking_method,'TO')
            %flag_is_mcs = 0;
            count_valid_length = 0;
            max_valid_length = 0;

            for j = 1:tracks(idx).age
                if tracks(idx).list_core(j) >= core_area_threshold %3500
                    count_valid_length = count_valid_length + 1;
                else
                    count_valid_length = 0;
                end
                if count_valid_length > max_valid_length
                    max_valid_length = count_valid_length;
                end
            end

            if max_valid_length >= age_threshold
                tracks(idx).is_mcs   = 1;
                mcs_id_array(end+1)  = tracks(idx).id; 
                record_tracks(end+1) = tracks(idx);
            end
        end
        %record_tracks(end+1)=tracks(idx);
    end
    % remove all unassinged tracks
    % lostInds(unassignedTracks)=1;
    tracks = tracks(~logical(lostInds));
end