function [assignments, unassignedTracks, unassignedDetections]...
    =get_overlapping_assignment(tracks, list_component, overlapping_rate_threshold)
    
    nTracks = length(tracks);
    nDetections = length(list_component);

    % Compute the cost of assigning each detection to each track.
    cost = ones(nTracks, nDetections)*inf;

    % Here we get cost matrix with max cost value as 100.
    for i=1:nTracks
        for j=1:nDetections
            
            if isempty(tracks(i).list_pixel{tracks(i).age})
                previous_time = tracks(i).age - tracks(i).consective_invisible_count;
            else
                previous_time = tracks(i).age;
            end

            overlapping_area=size(intersect(tracks(i).list_pixel{previous_time},list_component(j).pixels,'rows'),1);

            target_size=size(tracks(i).list_pixel{previous_time}, 1);
            %overlapping_rate=overlapping_area*100/target_size;

            %candidate_size=size(list_component(j).pixels,1);
            %overlapping_rate=overlapping_area*100/candidate_size;
            overlapping_rate=overlapping_area*100.0/target_size; % this allow the larger component to be chosed.

            if overlapping_rate<overlapping_rate_threshold
                cost(i,j)=inf;
            else
                cost(i,j)=100-overlapping_rate; % more overlapping, less cost
            end

            %cost(i,j)=100-overlapping_rate; % more overlapping, less cost

        end
    end

    % if there are more than one detections for one track, select the largest overlapping one;
    % then,if there are more than one tracks for a detection, select the
    % largest overlapping one. So there are only one track for one
    % detection, not global opitmal.
    for i=1:nTracks
        [min_d,idx_d]=min(cost(i,:));
        if min_d<100
            cost(i,:)=100;
            cost(i,idx_d)=min_d;
        end
    end
    for j=1:nDetections
        [min_t,idx_t]=min(cost(:,j));
        if min_t<100
            cost(:,j)=100;
            cost(idx_t,j)=min_t;
        end
    end

    costOfNonAssignment = 100; % overlapping rate is 0

    idx_assignments = 1;
    idx_unassignedTracks = 1;
    idx_unassignedDetections = 1;

    % for empty result, assign empty to output
    assignments = int64.empty(0,2);
    unassignedTracks = int64.empty();
    unassignedDetections = int64.empty();

    for i=1:nTracks
        [min_d,idx_d]=min(cost(i,:));
        if min_d<costOfNonAssignment
            assignments(idx_assignments,:) = [i, idx_d];
            idx_assignments = idx_assignments + 1;
        else
            unassignedTracks(idx_unassignedTracks) = i;
            idx_unassignedTracks = idx_unassignedTracks + 1;
        end 
    end

    for j=1:nDetections
        [min_t,idx_t]=min(cost(:,j));
        if min_t>=costOfNonAssignment
            unassignedDetections(idx_unassignedDetections) = j;
            idx_unassignedDetections = idx_unassignedDetections + 1;
        end
    end

    % Escape from initial situation where there is no tracks at all,
    % and cost matrix is empty.
    if nTracks == 0
        for j = 1:nDetections
            unassignedDetections(end+1) = j;
        end
    end

end