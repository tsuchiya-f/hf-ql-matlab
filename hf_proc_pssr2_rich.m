function [ret, auto] =hf_proc_pssr2_rich(ver, st_aux, st_hfa, raw_data)
    ret=0;
    [ret, auto] = hf_proc_pssr2_srv(ver, st_aux, st_hfa, raw_data)
end