function new_struct=get_new_track_struct()
% Move all struct defination here

new_struct = struct(...
            'id', 0, ... % numerical identity of MCS
            'kalmanFilter', [], ... % data structure for Kalman Filter
            'x', [],... % last center location x
            'y', [],... % last center location y
            'list_core_x', [],... % core center x location list for each time step
            'list_core_y', [],... 
            'list_shield_x', [],... % whole center x location list for each time step
            'list_shield_y', [],... 
            'list_shield', [],... % shield area list for each time step
            'list_core', [],... % core area list for each time step
            'list_time', [],... % --> absolute time step index 
            'list_pixel',{{}},... % --> list of pixel set, size is (n, 2)
            'list_temperature',{{}},... % --> list of temperature for each pixel
            'list_low_temperature', [],... 
            'list_avg_temperature', [],...
            'consective_invisible_count', 0,...
            'is_mcs', 0,...
            'age', 0); 

end