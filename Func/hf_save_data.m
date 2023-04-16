function hf_save_data(st_ctl)

    global st_data_spec
    global st_data_wave

    if ~isfield(st_data_spec, 'f'); return; end

    freq = st_data_spec.f(1,:);
    x_pow = transpose(st_data_spec.x);
    y_pow = transpose(st_data_spec.y);
    z_pow = transpose(st_data_spec.z);
    time = st_data_spec.t;
    
    sp_x = mean(x_pow,2);
    sp_y = mean(y_pow,2);
    sp_z = mean(z_pow,2);

    [filepath,name,ext] = fileparts(st_ctl.wfile);
    
    file_save = append(filepath, filesep, name, '.mat');
    
    save(file_save, 'freq','x_pow','y_pow','z_pow','time', 'sp_x', 'sp_y', 'sp_z', 'st_data_spec')

end