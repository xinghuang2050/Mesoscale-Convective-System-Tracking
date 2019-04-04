function to_decision_monitor...
    = init_to_decision_monitor(output_dir, tag_string)

    to_decision_monitor.to_lost = 0;
    to_decision_monitor.to_get = 0;
    to_decision_monitor.t_get_o_lost = 0;
    to_decision_monitor.o_get_t_lost = 0;
    to_decision_monitor.to_disagree = 0;
    to_decision_monitor.to_agree = 0;
    to_decision_monitor.to_conflict = 0;
    to_decision_monitor.all_decisions = 0;
    to_decision_monitor.to_log_fID = fopen(fullfile(output_dir,...
        sprintf('TO_log%s.txt', tag_string)), 'w');
end