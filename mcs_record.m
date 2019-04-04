function mcs_record(parameter_set)
is_rewrite  = parameter_set.is_MCS_rewrite;
MCS_file = parameter_set.MCS_file;
if exist(MCS_file,'file')==2 && ~is_rewrite
    fprintf(parameter_set.log_file, 'Already finalize MCSs %s. Return.\n',...
        MCS_file);
    return;
else      
claus_path = parameter_set.input_dir;
%claus_name = strcat('claus',parameter_set.tag_string,'.nc'); % any one claus file 
claus_name = strcat('AM4.0_olr',parameter_set.tag_string,'.nc'); % any one claus file 
LatData    = ncread(fullfile(claus_path,claus_name),'lat');
LonData    = ncread(fullfile(claus_path, claus_name),'lon');
latdata = LatData(120:241);
londata = LonData(1:576);

MCS_record = finalizeTracks();
load(parameter_set.record_tracks_file);  
%%  eliminated short-lived systems 
age = [record_tracks.age].';
records = record_tracks(age >= 3);

for i=1:length(records)
    MCS_record(i).id = i;
    track = records(i);
    MCS_record(i).frames = track.age;
    
    for j = 1:track.age
        
        MCS_record(i).glat(j) = latdata(round(track.list_shield_x(j)));
        MCS_record(i).glon(j) = londata(round(track.list_shield_y(j)));
        MCS_record(i).wlat(j) = latdata(round(track.list_core_x(j)));
        MCS_record(i).wlon(j) = londata(round(track.list_core_y(j)));

        MCS_record(i).size(j) = track.list_shield(j);
        MCS_record(i).eccen(j) = Fit_eccen(track.list_pixel{j}(:,1),track.list_pixel{j}(:,2));
        
        MCS_record(i).min_temp(j) = track.list_low_temperature(j);
        MCS_record(i).avg_temp(j) = track.list_avg_temperature(j);       
        MCS_record(i).list_time(j) = timestamp_2_date(track.list_time(j));
        if j > 1
        MCS_record(i).speed(j-1) = (distance(MCS_record(i).wlat(j),MCS_record(i).wlon(j),...
            MCS_record(i).wlat(j-1),MCS_record(i).wlon(j-1))/180*pi*6371)/3; 
        MCS_record(i).direct(j-1) =  atan2d(round(track.list_core_x(j-1))-round(track.list_core_x(j)),...
            round(track.list_core_y(j))-round(track.list_core_y(j-1)));
        end       
        MCS_record(i).list_grid{j} = track.list_pixel{j};
        MCS_record(i).list_deg{j}(:,1) = latdata(track.list_pixel{j}(:,1));
        MCS_record(i).list_deg{j}(:,2) = londata(track.list_pixel{j}(:,2));
        MCS_record(i).list_temp{j} = track.list_temperature{j};
    end   
end

end 
    save(MCS_file, 'MCS_record');
    fprintf(parameter_set.log_file, 'Save to %s.\n', MCS_file);
end
