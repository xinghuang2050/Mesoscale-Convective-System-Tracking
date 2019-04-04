function [assignments, unassignedTracks, unassignedDetections, to_decision_monitor]=...
        combine_overlapping_trajectory(...
        assignments_t,...
        assignments_o,...
        tracks,...
        list_component,...
        to_decision_monitor,...
        frame_index) 
%
% function: combine the trajectory of overlapping and trajectory prediction
%

    % We could design this function in another way by adding
    % assignments based on trajectory result.

    %trackIdx = assignments(i, 1);
    %detectionIdx = assignments(i, 2);

    nTracks = length(tracks);
    nDetections = length(list_component);

    assignments = zeros(0,2);
    unassignedTracks = [];
    unassignedDetections = 1:nDetections;
    detection2track = zeros(1,nDetections);

    to_decision_monitor.all_decisions = to_decision_monitor.all_decisions + nTracks;
    
    for i = 1:nTracks
       a_o = assignments_o(find(assignments_o(:,1)==i),2);
       a_t = assignments_t(find(assignments_t(:,1)==i),2);

       if isempty(a_o) && isempty(a_t)
           unassignedTracks(end+1) = i;
           to_decision_monitor.to_lost = to_decision_monitor.to_lost + 1;
       else
           to_decision_monitor.to_get = to_decision_monitor.to_get + 1;
           if ~isempty(a_o) && ~isempty(a_t)
               if a_o == a_t
                   a_final = a_t;
                   to_decision_monitor.to_agree = to_decision_monitor.to_agree + 1;
               else
                   %a_final = a_t;
                   a_final = a_o; % we trust overlapping more.
                   to_decision_monitor.to_disagree = to_decision_monitor.to_disagree + 1;
               end
           elseif ~isempty(a_o) &&  isempty(a_t)
               to_decision_monitor.o_get_t_lost = to_decision_monitor.o_get_t_lost + 1;
               a_final = a_o;
           elseif  isempty(a_o) && ~isempty(a_t)
               to_decision_monitor.t_get_o_lost = to_decision_monitor.t_get_o_lost + 1;
               a_final = a_t; % this is when we have no overlapping.
               fprintf(to_decision_monitor.to_log_fID, 'T get O lost, frame %03d, area %06d , track x %03d, track y %03d, detection x %03d, detection y %03d\n',...
               frame_index, list_component(a_t).shield, tracks(i).x, tracks(i).y, list_component(a_t).x, list_component(a_t).y);
           end

           if unassignedDetections(a_final) > 0
               unassignedDetections(a_final) = 0;
               assignments(end+1,1) = i;
               assignments(end,2) = a_final;
               detection2track(a_final) = i;
           else % conflict assignment
               to_decision_monitor.to_conflict = to_decision_monitor.to_conflict + 1;
               if ~isempty(a_t) % current is more important
                   pre_track = detection2track(a_final);
                   a_idx = find(assignments(:,1)==pre_track);
                   assert( assignments(a_idx,2)==a_final );
                   assignments(a_idx,1) = i;
                   unassignedTracks(end+1) = pre_track;
               else
                   unassignedTracks(end+1) = i;
               end
           end
       end
    end

    unassignedDetections = unassignedDetections(find(unassignedDetections));

    assert( length(assignments(:,1)) + length(unassignedTracks) == nTracks );
    assert( length(assignments(:,1)) + length(unassignedDetections) == nDetections );
end
