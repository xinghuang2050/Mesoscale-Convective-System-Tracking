function track_mcs_candidate(parameter_set)
    fprintf(parameter_set.log_file, '\nTrack MCS candidates.\n');
    tracking_method = parameter_set.tracking_method;
    is_rewrite      = parameter_set.is_track_rewrite;
  
    temperature_file = parameter_set.temperature_file;
    mask_image_file = parameter_set.mask_image_file;
    list_component_file = parameter_set.component_file;
    record_tracks_file = parameter_set.record_tracks_file;
    
    to_decision_monitor = parameter_set.to_decision_monitor;
    % init             
    nextID = 1;
    mcs_id_array = [];
    is_begin_date= true;
    timeStamp = date_2_timestamp(parameter_set.interest_date_begin, ...
                                is_begin_date); % Begin from first day in month
    record_begin_timestamp = date_2_timestamp(parameter_set.record_date_begin, ...
                                is_begin_date);
    record_end_timestamp = date_2_timestamp(parameter_set.record_date_end, ...
                                ~is_begin_date);
    
    
    tracks = initializeTracks();
    record_tracks = initializeTracks();
    

    
    
    tStart = tic;

    if exist(record_tracks_file,'file')==2 && ~is_rewrite
        fprintf(parameter_set.log_file, 'Already get results %s. Return.\n',...
            record_tracks_file);
        return;
    else
        fin = load(temperature_file);
        sequence = fin.output;
        fin = load(mask_image_file);
        mask_image_s = fin.mask_image_s;
        fin = load(list_component_file);
        list_component_s = fin.list_component_s;

        maxFrame = size(sequence, 1);
        fprintf(parameter_set.log_file, 'Total frame number: %d \n', maxFrame);
        for frame_index = 1:maxFrame    
            fprintf(parameter_set.log_file, '%d ', frame_index);
            frame = squeeze(sequence(frame_index,:,:));
            mask_image = squeeze(mask_image_s(frame_index,:,:));
            list_component = list_component_s(frame_index).value;

            if strcmpi(tracking_method,'trajectory')...
                    || strcmpi(tracking_method,'TO')
                tracks = predictNewLocationsOfTracks(tracks);
            end

            [assignments,...
             unassignedTracks,...
             unassignedDetections,...
             to_decision_monitor] = ...
                    detectionToTrackAssignment(...
                        tracking_method,...
                        tracks,...
                        list_component, ...
                        parameter_set.KF_distance_threshold,...
                        parameter_set.overlapping_rate_threshold,...
                        to_decision_monitor,...
                        frame_index);

            tracks = updateAssignedTracks(assignments,...
                tracking_method,...
                tracks,...
                list_component,...
                timeStamp);
            
            tracks = updateUnassignedTracks(unassignedTracks,...
                tracks,...
                timeStamp);
            
            
            if parameter_set.flag_core_only
                age_threshold = parameter_set.core_age_threshold;
            else
                age_threshold = parameter_set.age_threshold;
            end
            

            [tracks,...
            mcs_id_array,...
            record_tracks] = ...
            deleteUnassignedTracks(unassignedTracks,...
                tracking_method, tracks,... 
                parameter_set.core_area_threshold,...
                age_threshold,...
                mcs_id_array, record_tracks,...
                record_begin_timestamp,...
                record_end_timestamp,...
                parameter_set.invisible_count_threshold);
            
            
            

            [tracks, nextID] = createNewTracks(unassignedDetections,...
                            tracking_method,...
                            tracks,...
                            list_component,...
                            parameter_set.init_loc_var,...
                            parameter_set.init_v_var,...
                            parameter_set.noise_loc_var,...
                            parameter_set.noise_v_var,...
                            parameter_set.detect_loc_var,...
                            nextID,...
                            timeStamp);

            
            timeStamp = timeStamp + 1;
        end
        fprintf(parameter_set.log_file, '\nNumber of total mcs: %d\n',length(mcs_id_array));
      
    end
    tEnd = toc(tStart);
    fprintf(parameter_set.log_file, 'Time elapsed: %d minutes and %f seconds\n', floor(tEnd/60), rem(tEnd,60));
    % save for each file and clean up record, because data volumn is
    % too large for a single file. Here we need to save for the
    % MCS start within the record range.
    
    fprintf(parameter_set.log_file, 'Save to %s.\n', record_tracks_file);  
    save(record_tracks_file, 'record_tracks');
    save_to_decision_monitor(to_decision_monitor);
    
end


















