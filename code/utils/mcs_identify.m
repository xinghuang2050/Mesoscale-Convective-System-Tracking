function [output_image, list_component] =...
    mcs_identify(image, area_map,...
    flag_core_only, ...
    shield_temperature_threshold,...
    shield_area_threshold,...
    core_temperature_threshold,...
    core_area_threshold)

% INPUT
%     shield_temperature_threshold = 233 K
%     shield_area_threshold = 10000 km^2
%     core_temperature_threshold = 213 K
%     core_area_threshold = 500 km^2
% OUTPUT
%     list_component is structure array, index by group name:
%     shield: < 233K area, in km^2
%     core: <213 K area, in km^2
%     x,y: average position of core
%     x_shield,y_shield:average position of shield
%     pixels:pixel positions, [x1,y1;x2,y2]
%     is_mcs: boolean
%     tag: tag_of_component
%     core_count: number of core
%     shield_count: number of shield

%    assert(size(area_map,1)==size(image,1));
n_component=0;
output_image=zeros(size(image));
%%
if flag_core_only
    core_temperature_threshold = shield_temperature_threshold;
    core_area_threshold = shield_area_threshold;
end

% Maybe there is no component at all.
list_component(1).is_mcs = 0;

% find all component
for i=1:size(image,1)
    for j=1:size(image,2)
        if image(i,j)<=shield_temperature_threshold && image(i,j)>0
            % component number of previous pixels
            try
                p0=output_image(i-1,j-1);
            catch
                p0=0;
            end
            try
                p1=output_image(i-1,j);
            catch
                p1=0;
            end
            try
                p2=output_image(i-1,j+1);
            catch
                p2=0;
            end
            try
                p3=output_image(i,j-1);
            catch
                p3=0;
            end
            if max([p0,p1,p2,p3])==0
                % New component. Keep this, because we may have
                % n_component>1000
                n_component = n_component+1;
                
                % what changes with new pixel
                list_component(n_component).shield=0; % shield area
                list_component(n_component).core=0; % core area
                
                list_component(n_component).shield_count=0; % shield pixel count, redundant to pixels infomation, but we use it as a check point.
                list_component(n_component).core_count=0; % core pixel count
                
                list_component(n_component).pixels=[]; % pixel coordinate
                list_component(n_component).temperature=[]; % pixel temperature
                
                list_component(n_component).avg_temperature=0; % average temperature
                list_component(n_component).low_temperature=inf; % lowest temperature
                list_component(n_component).tag=n_component; % tag of component
                
                % what we calculate later
                list_component(n_component).x=0; % core average position
                list_component(n_component).y=0; %
                list_component(n_component).x_shield=0; % shield average position
                list_component(n_component).y_shield=0; %
                list_component(n_component).is_mcs=0;
                
                label=n_component;
            elseif max([p0,p3])~=p2 && max([p0,p3])>0 && p2>0
                % We got one component with 2 labels
                % Merge the one of p2 to the one of p0,p3
                label=max([p0,p3]);
                
                list_component(label).shield=list_component(label).shield+list_component(p2).shield;
                list_component(label).core=list_component(label).core+list_component(p2).core;
                list_component(label).shield_count=list_component(label).shield_count+list_component(p2).shield_count;
                list_component(label).core_count=list_component(label).core_count+list_component(p2).core_count;
                
                list_component(label).pixels=[list_component(label).pixels;list_component(p2).pixels];
                list_component(label).temperature=[list_component(label).temperature;list_component(p2).temperature];
                % remove p2
                output_image(output_image==p2)=label;
                list_component(p2).shield=0;
                list_component(p2).core=0;
                list_component(p2).shield_count=0;
                list_component(p2).core_count=0;
                list_component(p2).pixels=[];
                list_component(p2).temperature=[];
            else
                % only one label
                label=max([p0,p1,p2,p3]);
            end
            % add pixel (i,j) into the group, updata the group info
            output_image(i,j)=label;
            list_component(label).shield=list_component(label).shield+area_map(i);
            list_component(label).shield_count=list_component(label).shield_count+1;
            if image(i,j)<=core_temperature_threshold && image(i,j)>0
                list_component(label).core=list_component(label).core+area_map(i);
                list_component(label).core_count=list_component(label).core_count+1;
            end
            list_component(label).pixels(end+1,:)=[i,j];
            list_component(label).temperature(end+1,1)=image(i,j);
        end
    end
end

%% select by mcs candidate
for i=1:n_component
    if flag_core_only
        if list_component(i).core <= core_area_threshold
            list_component(i).is_mcs=0;
        else
            list_component(i).is_mcs=1;
        end
    else
        if list_component(i).shield <= shield_area_threshold %|| list_component(i).core<=core_area_threshold
            list_component(i).is_mcs=0;
        else
            list_component(i).is_mcs=1;
        end
    end
end

%% revisit the mask images, find core position
core_mark=2*n_component;
for j=1:size(image,2)
    for i=1:size(image,1)
        index = output_image(i,j); %index may be zero.
        % if index==0, output_image(i,j)=0 is true
        % else
        if index>0 && list_component(index).is_mcs==0
            output_image(i,j)=0;
        end
        % else
        if output_image(i,j)>0
            if image(i,j)<= core_temperature_threshold
                % Using mean
                list_component(index).x=list_component(index).x+i;
                list_component(index).y=list_component(index).y+j;
                %output_image(i,j)=core_mark;
            end
        end
    end
end

%% calculate positions fo mcs
for i=1:n_component
    if list_component(i).is_mcs==1
        
        assert(list_component(i).shield_count==size(list_component(i).pixels,1));
        %             list_component(i).x=list_component(i).x/list_component(i).core_count;
        %             list_component(i).y=list_component(i).y/list_component(i).core_count;
        test_x=list_component(i).x/list_component(i).core_count;
        test_y=list_component(i).y/list_component(i).core_count;
        
%         if length(list_component(i).temperature)<10
%             list_component(i).x = mean(list_component(i).pixels(:,1));
%             list_component(i).y = mean(list_component(i).pixels(:,2));
%             %                 assert(list_component(i).x == test_x ,'%f %f \n',list_component(i).x, test_x);
%             %                 assert(list_component(i).y == test_y);
%         else
            %% center of 10 lowest pixels
            %                 [sort_temperature, idx] = sort(list_component(i).temperature);
            %                 sort_pixels = list_component(i).pixels(idx(1:10),:);
            %                 list_component(i).x = mean(sort_pixels(:,1));
            %                 list_component(i).y = mean(sort_pixels(:,2));
            %% weighted center
            intensity = 233 - list_component(i).temperature;
            list_component(i).x  = dot(list_component(i).pixels(:,1),intensity)/sum(intensity);
            list_component(i).y  = dot(list_component(i).pixels(:,2),intensity)/sum(intensity);
            
        %end
        
        
        list_component(i).x_shield=mean(list_component(i).pixels(:,1));
        list_component(i).y_shield=mean(list_component(i).pixels(:,2));
        
        list_component(i).avg_temperature=mean(list_component(i).temperature);
        list_component(i).low_temperature=min(list_component(i).temperature);
        
    end
end

mcs_idx=[list_component(:).is_mcs]==1;
list_component=list_component(mcs_idx);
end
