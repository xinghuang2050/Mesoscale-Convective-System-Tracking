function [tracks, nextID]...
        =createNewTracks(unassignedDetections, tracking_method,...
        tracks, list_component,...
        init_loc_var, init_v_var,...
        noise_loc_var, noise_v_var,...
        detect_loc_var,...
        nextID, timeStamp)
    
    for i = 1:length(unassignedDetections)
        detectIdx=unassignedDetections(i);
        if strcmpi(tracking_method,'overlapping')
            centroid = [list_component(detectIdx).x_shield,list_component(detectIdx).y_shield];
        elseif strcmpi(tracking_method,'trajectory') || strcmpi(tracking_method,'TO')
            centroid = [list_component(detectIdx).x,list_component(detectIdx).y];
        end

        % Create a Kalman filter object.
        kalmanFilter = configureKalmanFilter('ConstantVelocity', ...
            centroid, [init_loc_var, init_v_var], [noise_loc_var, noise_v_var], detect_loc_var); %[5, 2], [5, 2], 5

        % Create a new track.
        newTrack = get_new_track_struct();
        newTrack.id = nextID;
        newTrack.kalmanFilter = kalmanFilter;
        newTrack.x = centroid(1);
        newTrack.y = centroid(2);
        newTrack.list_core_x = zeros(1,200);
        newTrack.list_core_y = zeros(1,200);
        newTrack.list_shield_x = zeros(1,200);
        newTrack.list_shield_y = zeros(1,200);
        newTrack.list_shield = zeros(1,200);
        newTrack.list_core = zeros(1,200);
        newTrack.list_time = zeros(1,200);
        newTrack.list_low_temperature = ones(1,200)*inf;
        newTrack.list_avg_temperature = zeros(1,200);
        newTrack.is_mcs = 0;
        newTrack.age = 1;
        

        newTrack.list_core_x(newTrack.age)=list_component(detectIdx).x;
        newTrack.list_core_y(newTrack.age)=list_component(detectIdx).y;
        newTrack.list_shield_x(newTrack.age)=list_component(detectIdx).x_shield;
        newTrack.list_shield_y(newTrack.age)=list_component(detectIdx).y_shield;
        newTrack.list_shield(newTrack.age)=list_component(detectIdx).shield;
        newTrack.list_core(newTrack.age)=list_component(detectIdx).core;
        newTrack.list_time(newTrack.age)=timeStamp;
        newTrack.list_pixel{newTrack.age}=list_component(detectIdx).pixels;
        newTrack.list_temperature{newTrack.age}=list_component(detectIdx).temperature;
        newTrack.list_low_temperature(newTrack.age)=list_component(detectIdx).low_temperature;
        newTrack.list_avg_temperature(newTrack.age)=mean(list_component(detectIdx).temperature);
        newTrack.consective_invisible_count = 0;
        % Add it to the array of tracks.
        tracks(end + 1) = newTrack;

        % Increment the next id.
        nextID = nextID + 1;
    end
end