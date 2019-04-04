function input_parser = default_parser()
% Parse input parameters. Set default value.
% TODO: add check function
input_parser = inputParser;
input_parser.addRequired('input_dir');
input_parser.addRequired('output_dir');

% rewrite options, for efficient running.
% if is_rewrite == true, compulsively set is_track_rewrite = true and
% is_mark_rewrite = true, is_IR_rewrite = true

%is_rewrite = true
%is_IR_rewrite = true
%is_mark_rewrite = true
%is_track_rewrite = true
%is_MCS_rewrite = true
%is_MCStxt_rewrite = true
input_parser.addParameter('is_rewrite', true);
input_parser.addParameter('is_IR_rewrite', true);
input_parser.addParameter('is_mark_rewrite', true);
input_parser.addParameter('is_track_rewrite', true);
input_parser.addParameter('is_MCS_rewrite', true);
input_parser.addParameter('is_MCStxt_rewrite', true);

% Options of tracking methods
% pure area-overlapping method---'overlapping'; pure Kalman Filter--'KF';
% use 'KF' based on 'OL' -- 'TO'

%tracking_method = 'TO'
input_parser.addParameter('tracking_method', 'TO'); 

% flag_core_only
input_parser.addParameter('flag_core_only', true);
%flag_core_only = true

input_parser.addParameter('shield_temperature_threshold', 148);
input_parser.addParameter('shield_area_threshold', 5000);
input_parser.addParameter('core_temperature_threshold', 148);
input_parser.addParameter('core_area_threshold', 5000);
%shield_temperature_threshold = 148
%shield_area_threshold = 5000
%core_temperature_threshold = 148
%core_area_threshold = 5000

% Object region -- entire tropics(30N~30S):latitude;longitude
input_parser.addParameter('x1', 120);
input_parser.addParameter('x2', 241);
input_parser.addParameter('y1', 1);
input_parser.addParameter('y2', 576);
%x1 = 120
%x2 = 241
%y1 = 1
%y2 = 576

% Object month 
%time_list = task_assign(1950, 2, 2010, 1, 360, 1);%array_size, array_id
%time_list = task_assign(1951, 2, 2011, 1, 120, 1);%array_size, array_id
time_list = task_assign(1941, 1, 1941, 1, 1, 1);%array_size, array_id
input_parser.addParameter('interest_date_begin', time_list.interest_begin_date);
input_parser.addParameter('interest_date_end', time_list.interest_end_date);
input_parser.addParameter('record_date_begin', time_list.record_begin_date);
input_parser.addParameter('record_date_end', time_list.record_begin_date);

% example: records for MCS generated in Jan 1986
% input_parser.addParameter('interest_date_begin', '01-Dec-1985');
% input_parser.addParameter('interest_date_end', '28-Feb-1986');
% input_parser.addParameter('record_date_begin', '01-Jan-1986');
% input_parser.addParameter('record_date_end', '31-Jan-1986');

% Overlapping rate threshold, percentage
input_parser.addParameter('overlapping_rate_threshold', 15);
%overlapping_rate_threshold = 15
% Kalman Filter parameters, units based on pixel
input_parser.addParameter('KF_distance_threshold', 25); 
input_parser.addParameter('init_loc_var', 1);
input_parser.addParameter('init_v_var', 3);
input_parser.addParameter('noise_loc_var', 3);
input_parser.addParameter('noise_v_var', 3);
input_parser.addParameter('detect_loc_var', 1);
%KF_distance_threshold = 25
%init_loc_var = 1
%init_v_var = 3
%noise_loc_var = 3
%noise_v_var = 3
%detect_loc_var = 1

% Persistence time, from number of snapshot
input_parser.addParameter('age_threshold', 3);
input_parser.addParameter('core_age_threshold', 3);
%age_threshold = 3
%core_age_threshold = 3

% if is_use_pixel == true, use pixel as coverage area unit;
% otherwise, use km^2 as area unit.
input_parser.addParameter('is_use_pixel', false);
%is_use_pixel = false 

% 
input_parser.addParameter('invisible_count_threshold', 0);
%invisible_count_threshold = 0
end
