function month_begin_date = monthIndex_2_datestr(index)
    index = index - 1;
    year = floor(index / 12);
    month = mod(index, 12) + 1;
    month_begin_date = datestr(datenum(year, month, 1),'yyyy-mm-dd');
end

