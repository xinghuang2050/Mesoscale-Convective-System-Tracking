function tracks = updateUnassignedTracks(unassignedTracks, tracks, timeStamp)
    for i = 1:length(unassignedTracks)
        idx = unassignedTracks(i);
        tracks(idx).age = tracks(idx).age + 1;
        tracks(idx).list_time(tracks(idx).age) = timeStamp;
        tracks(idx).consective_invisible_count = ...
            tracks(idx).consective_invisible_count + 1;
        % We do not update other informations. Because they will be rightly
        % handled in updateAssignedTracks by a(+5) = 9.
        
        %tracks(idx).list_pixel{tracks(idx).age} = tracks(idx).list_pixel{tracks(idx).age-1};
        %tracks(idx).list_temperature{tracks(idx).age} = tracks(idx).list_temperature{tracks(idx).age-1};
        
        % list_pixels are used both for tracking assignment and record.
        tracks(idx).list_pixel{tracks(idx).age} = []; % expand the length
        tracks(idx).list_temperature{tracks(idx).age} = [];
        % list_core_x is only used for record.
        %tracks(idx).list_core_x{tracks(idx).age} = tracks(idx).list_core_x{tracks(idx).age - 1};
        %tracks(idx).list_core_y{tracks(idx).age} = tracks(idx).list_core_y{tracks(idx).age - 1};
    end
end