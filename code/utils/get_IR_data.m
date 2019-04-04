function get_IR_data(parameter_set)
% Extract IR data from nc files for given time and space range.
fprintf(parameter_set.log_file, '\nExtract and merge nc files.\n');

if exist(parameter_set.temperature_file, 'file')==2 && ~parameter_set.is_IR_rewrite
    fprintf(parameter_set.log_file, '%s exists. Return.\n',...
       parameter_set.temperature_file);
    return;
end

% set the beginning of the day: is_begin_date= true

is_begin_date = true;

interest_begin_timeStamp = date_2_timestamp(parameter_set.interest_date_begin, ...
                            is_begin_date);
                   
interest_end_timeStamp = date_2_timestamp(parameter_set.interest_date_end, ...
                            ~is_begin_date);
                     
% TODO: Here need to handle the exceptions
output = zeros(interest_end_timeStamp - interest_begin_timeStamp + 1,...
    parameter_set.x2 - parameter_set.x1 + 1,...
    parameter_set.y2 - parameter_set.y1 + 1);

% Not easy to directly index date string. We use month index.
tmp = datevec(parameter_set.interest_date_begin);
interest_month_begin = 12 * tmp(1) + tmp(2);

tmp = datevec(parameter_set.interest_date_end);
interest_month_end = 12 * tmp(1) + tmp(2);


for month_index = interest_month_begin : interest_month_end
    
    nc_file = fullfile(parameter_set.input_dir, monthIndex_2_filename(month_index));
    
    fprintf(parameter_set.log_file, '%s\n', nc_file);
    
    sequence = read_nc(nc_file, ...
            parameter_set.x1,...
            parameter_set.x2,...
            parameter_set.y1,...
            parameter_set.y2);
    sequence_length = size(sequence, 1);

    % Begin from first day in month
    nc_begin_timeStamp = date_2_timestamp(monthIndex_2_datestr(month_index), is_begin_date);
    nc_end_timeStamp = nc_begin_timeStamp + sequence_length - 1;
    
    if nc_begin_timeStamp >= interest_begin_timeStamp
        nc_idx1 = 1;
        output_idx1 = nc_begin_timeStamp - interest_begin_timeStamp + 1;
    else
        nc_idx1 = interest_begin_timeStamp - nc_begin_timeStamp + 1;
        output_idx1 = 1;    
    end
    if nc_end_timeStamp <= interest_end_timeStamp
        nc_idx2 = sequence_length;
        output_idx2 = nc_end_timeStamp - interest_begin_timeStamp + 1;
    else
        nc_idx2 = interest_end_timeStamp - nc_begin_timeStamp + 1;
        output_idx2 = interest_end_timeStamp - interest_begin_timeStamp + 1;
    end
    output(output_idx1:output_idx2, :, :) = sequence(nc_idx1:nc_idx2, :, :);
end
%TODO: check if all data read complete

save(parameter_set.temperature_file, 'output');
fprintf(parameter_set.log_file, 'Save to %s.\n', parameter_set.temperature_file);
end
