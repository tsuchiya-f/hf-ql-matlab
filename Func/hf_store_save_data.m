function ret = hf_store_save_data(st_ctl, st_aux, st_time, spec)

    global st_data_spec
    global st_data_wave
    
    ret = 0;
    nb = int16(st_aux.n_block);
    nf = numel(spec.f) / nb;
        
    if st_data_spec.nf == -1
        % the first data
        i=1;
        st_data_spec.nf = nf;
        st_data_spec.t = double(st_time.cuc_time_elapse);
        st_data_spec.x = transpose(spec.x(nf*(i-1)+1:nf*i,1));
        st_data_spec.y = transpose(spec.y(nf*(i-1)+1:nf*i,1));
        st_data_spec.z = transpose(spec.z(nf*(i-1)+1:nf*i,1));

        st_data_spec.xx = transpose(spec.xx(nf*(i-1)+1:nf*i,1));
        st_data_spec.yy = transpose(spec.yy(nf*(i-1)+1:nf*i,1));
        st_data_spec.zz = transpose(spec.zz(nf*(i-1)+1:nf*i,1));

        st_data_spec.re_xy = transpose(spec.re_xy(nf*(i-1)+1:nf*i,1));
        st_data_spec.im_xy = transpose(spec.im_xy(nf*(i-1)+1:nf*i,1));
        st_data_spec.re_yz = transpose(spec.re_yz(nf*(i-1)+1:nf*i,1));
        st_data_spec.im_yz = transpose(spec.im_yz(nf*(i-1)+1:nf*i,1));
        st_data_spec.re_zx = transpose(spec.re_zx(nf*(i-1)+1:nf*i,1));
        st_data_spec.im_zx = transpose(spec.im_zx(nf*(i-1)+1:nf*i,1));
        
        st_data_spec.f = spec.f(nf*(i-1)+1:nf*i);
        
        if nb>1
        for i=2:nb
            st_data_spec.t = [st_data_spec.t; double(st_time.cuc_time_elapse) + double(i-1)/double(st_aux.n_block)];
            st_data_spec.x = [st_data_spec.x; transpose(spec.x(nf*(i-1)+1:nf*i,1))];
            st_data_spec.y = [st_data_spec.y; transpose(spec.y(nf*(i-1)+1:nf*i,1))];
            st_data_spec.z = [st_data_spec.z; transpose(spec.z(nf*(i-1)+1:nf*i,1))];

            st_data_spec.xx = [st_data_spec.xx; transpose(spec.xx(nf*(i-1)+1:nf*i,1))];
            st_data_spec.yy = [st_data_spec.yy; transpose(spec.yy(nf*(i-1)+1:nf*i,1))];
            st_data_spec.zz = [st_data_spec.zz; transpose(spec.zz(nf*(i-1)+1:nf*i,1))];

            st_data_spec.re_xy = [st_data_spec.re_xy; transpose(spec.re_xy(nf*(i-1)+1:nf*i,1))];
            st_data_spec.im_xy = [st_data_spec.im_xy; transpose(spec.im_xy(nf*(i-1)+1:nf*i,1))];
            st_data_spec.re_yz = [st_data_spec.re_yz; transpose(spec.re_yz(nf*(i-1)+1:nf*i,1))];
            st_data_spec.im_yz = [st_data_spec.im_yz; transpose(spec.im_yz(nf*(i-1)+1:nf*i,1))];
            st_data_spec.re_zx = [st_data_spec.re_zx; transpose(spec.re_zx(nf*(i-1)+1:nf*i,1))];
            st_data_spec.im_zx = [st_data_spec.im_zx; transpose(spec.im_zx(nf*(i-1)+1:nf*i,1))];

            st_data_spec.f = [st_data_spec.f; spec.f(nf*(i-1)+1:nf*i)];
        end
        end
        
    else
        [~,nf_] = size(st_data_spec.x);
        if nf ~= nf_
            fprintf("Number of frequency bin dose not match. Skip to save st_data_spec in hf_store_save_data.");
        else
            for i=1:nb
                st_data_spec.t = [st_data_spec.t; double(st_time.cuc_time_elapse) + double(i-1)/double(st_aux.n_block)];
                st_data_spec.x = [st_data_spec.x; transpose(spec.x(nf*(i-1)+1:nf*i,1))];
                st_data_spec.y = [st_data_spec.y; transpose(spec.y(nf*(i-1)+1:nf*i,1))];
                st_data_spec.z = [st_data_spec.z; transpose(spec.z(nf*(i-1)+1:nf*i,1))];

                st_data_spec.xx = [st_data_spec.xx; transpose(spec.xx(nf*(i-1)+1:nf*i,1))];
                st_data_spec.yy = [st_data_spec.yy; transpose(spec.yy(nf*(i-1)+1:nf*i,1))];
                st_data_spec.zz = [st_data_spec.zz; transpose(spec.zz(nf*(i-1)+1:nf*i,1))];

                st_data_spec.re_xy = [st_data_spec.re_xy; transpose(spec.re_xy(nf*(i-1)+1:nf*i,1))];
                st_data_spec.im_xy = [st_data_spec.im_xy; transpose(spec.im_xy(nf*(i-1)+1:nf*i,1))];
                st_data_spec.re_yz = [st_data_spec.re_yz; transpose(spec.re_yz(nf*(i-1)+1:nf*i,1))];
                st_data_spec.im_yz = [st_data_spec.im_yz; transpose(spec.im_yz(nf*(i-1)+1:nf*i,1))];
                st_data_spec.re_zx = [st_data_spec.re_zx; transpose(spec.re_zx(nf*(i-1)+1:nf*i,1))];
                st_data_spec.im_zx = [st_data_spec.im_zx; transpose(spec.im_zx(nf*(i-1)+1:nf*i,1))];

                st_data_spec.f = [st_data_spec.f; spec.f(nf*(i-1)+1:nf*i)];
            end
        end

    end
     
end