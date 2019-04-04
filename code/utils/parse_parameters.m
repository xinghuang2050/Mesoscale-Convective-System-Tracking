function parameter_set = parse_parameters(input_dir, output_dir,...
                                          varargin_list)
% Parse input paraemters.
% Prepare directories and files for the whole workflow,
% Return parameter set.

    % Parse input paraemters.
    input_parser = default_parser();
    
    if isempty(varargin_list) 
        input_parser.parse(input_dir, output_dir);
    else
        input_parser.parse(input_dir, output_dir, varargin_list{:});
    end
    
    parameter_set = input_parser.Results;
% rewrite options, for efficient running, defaults are false
% an updated experiments always set the options to be true
    if parameter_set.is_rewrite == true       
        parameter_set.is_IR_rewrite = true;
        parameter_set.is_mark_rewrite = true;
        parameter_set.is_track_rewrite = true;  
        parameter_set.is_MCS_rewrite = true; 
        parameter_set.is_MCS_txt = true; 
    end
    
    % Prepare input/output directories and files.
    if ~exist(parameter_set.output_dir,'dir')
        mkdir(parameter_set.output_dir);
    end  
    % single output file for each run.
    output_file_date = datestr(parameter_set.record_date_begin,'yyyy-mm');
    parameter_set.tag_string = strcat('_',output_file_date);

    
    tag_string_matfile = strcat(parameter_set.tag_string, '.mat');
    
    parameter_set.temperature_file = fullfile(parameter_set.output_dir, ...
        strcat('IR', tag_string_matfile));
    parameter_set.mask_image_file = fullfile(parameter_set.output_dir, ...
        strcat('mask_image', tag_string_matfile));
    parameter_set.component_file = fullfile(parameter_set.output_dir, ...
        strcat('component', tag_string_matfile)); 
    parameter_set.record_tracks_file = fullfile(parameter_set.output_dir, ...
        strcat('record_tracks', tag_string_matfile));
    parameter_set.MCS_file = fullfile(parameter_set.output_dir, ...
        strcat('MCS', tag_string_matfile));
    parameter_set.MCS_filetxt = fullfile(parameter_set.output_dir, ...
        strcat('MCS_record', parameter_set.tag_string,'.txt'));

    
  
  
    
    
    parameter_set.to_decision_monitor = init_to_decision_monitor(...
                                        parameter_set.output_dir,...
                                        parameter_set.tag_string);
    
    % Print parameter parser results to stdout
    parameter_table = struct2table(parameter_set);
    logfile_name = fullfile(parameter_set.output_dir,...
        strcat('log_file', parameter_set.tag_string, '.txt'));
    
    writetable(parameter_table, logfile_name);
    
    parameter_set.log_file = fopen(logfile_name, 'a');
    
end
