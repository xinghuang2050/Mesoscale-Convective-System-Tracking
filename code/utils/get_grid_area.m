%% area for each grid
function grid_area = get_grid_area(lat_begin,lat_end,...
                                   is_use_pixel)
%% if is_use_pixel == false,grid area with unit 1
% Get surface area for grid cells. https://badc.nerc.ac.uk/help/coordinates/cell-surf-area.html
% grid_area: grid area in km^2
% lat_begin,lat_end: limit of grid, only change in longitude direction

long_grid = 576; % total longitude grid number of CLAUS
lat_grid = 358;   % total longitude grid number of CLAUS; =360-2
lat_deg = (-89.75:1/2:89.75); % resolution of CLAUS

grid_area = zeros(lat_grid,1);
R = 6371;
perl = 2*pi/long_grid;
for i = 2:lat_grid+1
    phi2 = (lat_deg(i)+lat_deg(i-1))/360.*pi;
    phi1 = (lat_deg(i)+lat_deg(i+1))/360.*pi;
    grid_area(i-1) = R*R*perl*abs(sin(phi2)-sin(phi1));
end
grid_area=grid_area(lat_begin:lat_end,1);
%% if is_use_pixel == true,grid area with unit 1
if is_use_pixel
    grid_area(:)=1;
end
end
