function convert_tracks_2_num_labels(parameter_set, ...
    tracks_file,...
    num_label_file)
% Mark record tracks on matrix
    fprintf(parameter_set.log_file, 'Convert tracks to labels.\n');
    
    fin = load(tracks_file);
    data_name = fieldnames(fin);
    record_tracks = fin.(data_name{1});
    
    fin = load(parameter_set.temperature_file);
    IR = fin.output;
    
    is_begin_date = true;
    begin_timeStamp = date_2_timestamp(parameter_set.interest_date_begin, is_begin_date);
    
    label = zeros(size(IR));
    
    tStart = tic;
    for i = 1:length(record_tracks)
        track = record_tracks(i);
        for t = 1:track.age
            time_stamp = track.list_time(t);
            if isempty(track.list_pixel{t})
                continue;
            end
            frame_idx = time_stamp - begin_timeStamp + 1;
            pixel_idx = sub2ind(size(label),...
                repmat(frame_idx, size(track.list_pixel{t}, 1),1),...
                track.list_pixel{t}(:,1),...
                track.list_pixel{t}(:,2));
            label(pixel_idx) = track.id;
        end
    end
    
    fprintf(parameter_set.log_file, 'Save to %s.\n', num_label_file);
    tEnd = toc(tStart);
    fprintf(parameter_set.log_file, 'Time elapsed: %d minutes and %f seconds\n', floor(tEnd/60), rem(tEnd,60));
    
    save(num_label_file, 'label');

end