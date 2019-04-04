function mark_mcs_candidate(parameter_set)

% Detect MCS candidate on each frame. Call function MCS_detect

fprintf(parameter_set.log_file, '\nMark MCS candidates.\n');

% Show related parameters
flag_core_only                  = parameter_set.flag_core_only;
shield_temperature_threshold    = parameter_set.shield_temperature_threshold;
shield_area_threshold           = parameter_set.shield_area_threshold;
core_temperature_threshold      = parameter_set.core_temperature_threshold;
core_area_threshold             = parameter_set.core_area_threshold;
is_rewrite                      = parameter_set.is_mark_rewrite;

% Begin mark
area_map = get_grid_area( parameter_set.x1, parameter_set.x2, ...
                          parameter_set.is_use_pixel);

tStart = tic;

temperature_file = parameter_set.temperature_file;
mask_image_file  = parameter_set.mask_image_file;
list_component_file = parameter_set.component_file;

if exist(mask_image_file, 'file')==2 && ~is_rewrite
    fprintf(parameter_set.log_file, 'mask images %s and list component %s exist, break.\n',...
        mask_image_file, list_component_file);
    return;
end

fin = load(temperature_file);
sequence = fin.output;

mask_image_s=zeros(size(sequence));
maxFrame=size(sequence,1);

fprintf(parameter_set.log_file, 'Total frame number: %d \n', maxFrame);

for idxFrame=1:maxFrame
    fprintf(parameter_set.log_file, '%d ', idxFrame);
    
    frame = squeeze(sequence(idxFrame,:,:));
    
    [ans1,ans2] = mcs_identify(frame,...
        area_map,...
        flag_core_only, ...
        shield_temperature_threshold,...
        shield_area_threshold,...
        core_temperature_threshold,...
        core_area_threshold);
    
    mask_image_s(idxFrame,:,:)=ans1;
    list_component_s(idxFrame).value=ans2; %#ok<AGROW,NASGU>
end
fprintf(parameter_set.log_file, '\n Saving to %s and %s.\n', mask_image_file, list_component_file);
save(mask_image_file, 'mask_image_s');
save(list_component_file, 'list_component_s');

tEnd = toc(tStart);
fprintf(parameter_set.log_file, 'Time elapsed: %d minutes and %f seconds\n', floor(tEnd/60), rem(tEnd,60));
end