function save_to_decision_monitor(to_decision_monitor)
    fprintf(to_decision_monitor.to_log_fID, 'to lost track %d \n', to_decision_monitor.to_lost);
    fprintf(to_decision_monitor.to_log_fID, 'to continue get track %d \n', to_decision_monitor.to_get);
    fprintf(to_decision_monitor.to_log_fID, 't_get_o_lost %d \n', to_decision_monitor.t_get_o_lost);
    fprintf(to_decision_monitor.to_log_fID, 'o_get_t_lost %d \n', to_decision_monitor.o_get_t_lost);
    fprintf(to_decision_monitor.to_log_fID, 'to_disagree %d \n', to_decision_monitor.to_disagree);
    fprintf(to_decision_monitor.to_log_fID, 'to_agree %d \n', to_decision_monitor.to_agree);
    fprintf(to_decision_monitor.to_log_fID, 'to_conflict %d \n', to_decision_monitor.to_conflict);
    fprintf(to_decision_monitor.to_log_fID, 'all_decisions %d \n', to_decision_monitor.all_decisions);
    fclose(to_decision_monitor.to_log_fID);
end