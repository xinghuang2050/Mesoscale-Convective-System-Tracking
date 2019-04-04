function tag_string = mcsDetect(input_dir, output_dir, varargin)
 
parameter_set = parse_parameters(input_dir, output_dir, varargin);

tStart = tic;

fprintf(parameter_set.log_file,...
    '\nMCS detection begins at %s.\n', datestr(clock));

get_IR_data(parameter_set);

mark_mcs_candidate(parameter_set);

track_mcs_candidate(parameter_set);

mcs_record(parameter_set)
mcs_2txt(parameter_set)

fprintf(parameter_set.log_file,...
    '\nMCS detection ends at %s.\n', datestr(clock));

tEnd = toc(tStart);

fprintf(parameter_set.log_file, ...
    'Time elapsed for whole detection: %d minutes and %f seconds\n',...
    floor(tEnd/60), rem(tEnd,60));

fclose(parameter_set.log_file);

tag_string = parameter_set.tag_string;
end
