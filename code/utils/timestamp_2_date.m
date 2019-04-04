

function datet = timestamp_2_date(timestamp)
%--dmt = timestamp_2_time(timestamp,timezone)
start_day = datenum(sprintf('%d/01/%d', 1, 0));
%--Defalt UTC timezone=0;
datet = addtodate(start_day, (timestamp- 1)  * 3, 'hour');
%--date = addtodate(date,timezone, 'hour');
%--For LST,timezone depends on longitude

%datet = datestr(date,'yyyy-mm-dd-HH');

end

