function sequence = read_nc(file_name, x1, x2, y1, y2)
% TODO: Here need to handle the exceptions
    % Get data of interesting area, x[0,540],y[0,1080]
    %
    % Input: 
    %       1, claus nc files, 
    %       dimensions:
    % 	    level = 1 ;
    %       latitude = 539 ;
    %       longitude = 1080 ;
    %       time = UNLIMITED ; // (248 currently)
    %
    %                    North
    %        (i=0, j=0)     (i=1079, j=0)          East
    %        (i=0, j=538)   (i=1079, j=538)
    %
    %        [i-longitude, j-latitude, level=1, time=day_in_month*8]
    %
    %       2, rectangle vertex
    %           (x1, y1) *    *
    %                    *    * (x2, y2)
    % Ouput: 
    %       1, sequence, 3D matrix, [time, latitude-x, longitude-y]
    %
    %                    North
    %        (x=1, y=1)     (x=1, y=1080)          East
    %        (x=539, y=1)   (x=539, y=1080)
    %               
    % Tropical: area=data(:,180:360,:); % 30N~30S, % global tropical
    % 

    data = ncread(file_name,'olr'); 
    data = squeeze(data);         % size [1080, 539, 248] 
    data = permute(data,[3,2,1]); % size [248, 539, 1080]
    area = data(:, x1:x2, y1:y2);
    sequence = area;
    %---------------------

end
