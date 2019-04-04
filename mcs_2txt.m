function mcs_2txt(parameter_set)
is_rewrite  = parameter_set.is_MCStxt_rewrite;
txt_file = parameter_set.MCS_filetxt;
if exist(txt_file,'file')==2 && ~is_rewrite
    fprintf(parameter_set.log_file, 'Already convert MCS record to txt %s. Return.\n',...
        txt_file);
    return;
else     
%% 
fid = fopen(fullfile(parameter_set.MCS_filetxt),'w');
fprintf(fid, '%s\t',...
'ID','Lifetime(hour)',...
'gLat(N)','gLon(E)','wLat(N)','wLon(E)',...
'Size(km^2)','Eccentricity',...
'BTavg(K)','BTmin(K)',...
'Time(UTC)','Speed(km/h)','Direction(deg)');
fprintf(fid, '\n');
load(parameter_set.MCS_file);
for i = 1:length(MCS_record)
    track = MCS_record(i);
    for j = 1:track.frames
        %id = track.id;
        id = i;
        life = (track.frames-1)*3;
        gLat = track.glat(j);
        gLon = track.glon(j);
        wLat = track.wlat(j);
        wLon = track.wlon(j);
        size = track.size(j);
        eccen =track.eccen(j);
        tpavg = track.avg_temp(j);
        tpmin = track.min_temp(j);   
        time = datestr(track.list_time(j),'yyyy-mm-dd-HH');
        if j < track.frames
        speedv = track.speed(j);   
        direct = track.direct(j);
        else
        speedv = NaN;   
        direct = NaN;
        end

        fprintf(fid, '%i %i %.4f %.4f %.4f %.4f %i %.2f %.2f %.2f %s %.2f %.1f\t',....
                id,life,gLat,gLon,wLat,wLon,size,eccen,tpavg,tpmin,time,speedv,direct);
        fprintf(fid, '\n');
    end
end
end