function ret = hf_store_save_data(st_ctl, st_time, spec)

    global st_data_spec
    global st_data_wave
    
    ret = 0;
    
    if st_data_spec.nf == -1
        % the first data
        st_data_spec.nf = numel(spec.f);
        st_data_spec.t = st_time.cuc_time_elapse;
        st_data_spec.x = transpose(spec.x);
        st_data_spec.y = transpose(spec.y);
        st_data_spec.z = transpose(spec.z);
        st_data_spec.f = spec.f;
    else
        st_data_spec.t = [st_data_spec.t; st_time.cuc_time_elapse];
        st_data_spec.x = [st_data_spec.x; transpose(spec.x)];
        st_data_spec.y = [st_data_spec.y; transpose(spec.y)];
        st_data_spec.z = [st_data_spec.z; transpose(spec.z)];
        st_data_spec.f = [st_data_spec.f; spec.f];
    end
     
end