function timestamp = date_2_timestamp(date_string, is_begin_date)
% Get 3 hours time stamp index from 01-Jan-0000

start_day = daysact(date_string);

if is_begin_date
    timestamp = (start_day - 1) * 8 + 1;
else
    timestamp = start_day * 8;
end
end