%% for parallel computing
function time_list = task_assign(yr1, mt1, yr2, mt2, array_size, array_id)

total_month = (yr2 - yr1)*12 + (mt2 - mt1) + 1
% eg. if set array_size == total_month --> assign tasks for each month 
month_for_each_proc = round(total_month/array_size)

start_day = datenum(sprintf('%d/01/%d', mt1, yr1))

time_list.record_begin_date = datestr(addtodate(start_day, (array_id - 1)  * month_for_each_proc, 'month'),'yyyy-mm-dd');
time_list.record_end_date   = datestr(addtodate(start_day-1, array_id * month_for_each_proc, 'month'),'yyyy-mm-dd');

time_list.interest_begin_date = datestr(addtodate(start_day, (array_id - 1)  * month_for_each_proc - 1, 'month'),'yyyy-mm-dd');
time_list.interest_end_date   = datestr(addtodate(start_day-1, array_id * month_for_each_proc+1, 'month'),'yyyy-mm-dd');

end
