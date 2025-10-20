function [st] = hf_get_aux(aux, sid, st_ctl)

%-----------------------------------
%   SID for SW ver.2 & later
%-----------------------------------
%    st_ctl.sid_raw     = 0x42;
%    st_ctl.sid_full    = 0x43;
%    st_ctl.sid_burst_s = 0x44;
%    st_ctl.sid_pssr1_s = 0x45 (69);
%    st_ctl.sid_pssr2_s = 0x46;
%    st_ctl.sid_pssr3_s = 0x47;
%    st_ctl.sid_burst_r = 0x64;
%    st_ctl.sid_pssr1_r = 0x65;
%    st_ctl.sid_pssr2_r = 0x66;
%    st_ctl.sid_pssr3_r = 0x67;
% 

    if st_ctl.ver == 1.0
        
        % there is no valid Aux file for Ver.1 SW
        
        % HF header size
        st.hf_hdr_len = 24;
        % Channel select
        st.xch_sel     = 1;
        st.ych_sel     = 1;
        st.zch_sel     = 1;
        st.bg_downlink = 0;
        st.n_block = 1;
        return;
    end
    
    switch sid
        
        case {st_ctl.sid_raw, st_ctl.sid_full, st_ctl.sid_burst_r, st_ctl.sid_burst_s, st_ctl.sid_pssr1_r, st_ctl.sid_pssr1_s}
            % Unique ID
            st.unique_id = uint32(aux(1))*256 + uint32(aux(2));
            % HF header size
            st.hf_hdr_len = double(bitshift(bitand(aux(3),0xF0),-4) * 4.0);
            % Channel select
            st.xch_sel     = bitshift(bitand(aux(3),0x08),-3);
            st.ych_sel     = bitshift(bitand(aux(3),0x04),-2);
            st.zch_sel     = bitshift(bitand(aux(3),0x02),-1);
            st.cal_ena     = bitand(aux(3),0x01);
            % Sweep table ID
            st.sweep_table_id  = bitshift(bitand(aux(4),0xf8),-3);
            % TLM format
            st.power_sel   = bitshift(bitand(aux(4),0x04),-2);
            st.complex_sel = bitand(aux(4),0x03);
            st.bg_subtract = bitshift(bitand(aux(5),0x80),-7);
            st.bg_select  = bitshift(bitand(aux(5),0x40),-6);
            st.fft_win     = bitshift(bitand(aux(5),0x20),-5);
            st.rfi_rej_sw  = bitshift(bitand(aux(5),0x10),-4);
            st.pol_sep_th  = bitand(aux(5),0x0f);
            st.pol_sel     = bitshift(bitand(aux(6),0xc0),-6);
%            st.ovf_stat_x  = bitshift(bitand(aux(6),0x30),-4);
%            st.ovf_stat_y  = bitshift(bitand(aux(6),0x0c),-2);
%            st.ovf_stat_z  = bitand(aux(6),0x03);
            st.rfi_param0  = aux(7);
            st.rfi_param1  = aux(8);
            st.rfi_param2  = aux(9);
            st.rfi_param3  = aux(10);
            st.bg_downlink = bitshift(bitand(aux(11),0xc0),-6);
            st.n_block     = bitshift(bitand(aux(11),0x38),-3);
            st.rich_exist  = bitshift(bitand(aux(11),0x04),-2);
            % Temperature
            value = double(uint16(aux(14)));
            st.temp_rwi_a  = value * 2.0 - 200.0;
            value = double(uint16(aux(15)));
            st.temp_rwi_b  = value * 2.0 - 200.0;
            value = double(uint16(aux(16)));
            st.temp_hf  = value - 55.0;

        case {st_ctl.sid_pssr2_s, st_ctl.sid_pssr2_r}
            % Unique ID
            st.unique_id = uint32(aux(1))*256 + uint32(aux(2));
            % HF header size
            st.hf_hdr_len = double(bitshift(bitand(aux(3),0xF0),-4) * 4.0);
            % Channel select
            ant_sel       = bitshift(bitand(aux(3),0x0C),-2);
            st.xch_sel=0;
            st.ych_sel=0;
            st.zch_sel=0;
            if ant_sel == 0
                st.xch_sel = 1;
            elseif ant_sel == 1 
                st.ych_sel    = 1;
            elseif ant_set == 2 
                st.zch_sel    = 1;
            else
                st.xch_sel    = 1;
            end
            st.cal_ena    = bitand(aux(3),0x01);
            % Sweep table ID
            st.sweep_table_id  = bitshift(bitand(aux(4),0xf8),-3);
            st.fft_win    = bitshift(bitand(aux(4),0x04),-2);
            st.rfi_rej_sw = bitshift(bitand(aux(4),0x02),-1);
            st.n_lag   = uint32(aux(5))*256 + uint32(aux(6));

            st.rfi_param0  = aux(9);
            st.rfi_param1  = aux(10);
            st.rfi_param2  = aux(11);
            st.rfi_param3  = aux(12);

            % Temperature
            value = double(uint16(aux(14)));
            st.temp_rwi_a  = value * 2.0 - 200.0;
            value = double(uint16(aux(15)));
            st.temp_rwi_b  = value * 2.0 - 200.0;
            value = double(uint16(aux(16)));
            st.temp_hf  = value - 55.0;
            
            st.n_block = 1;

        case {st_ctl.sid_pssr3_s, st_ctl.sid_pssr3_r}
            % Unique ID
            st.unique_id = uint32(aux(1))*256 + uint32(aux(2));
            % HF header size
            st.hf_hdr_len = double(bitshift(bitand(aux(3),0xF0),-4) * 4.0);
            % Channel select
            st.xch_sel     = bitshift(bitand(aux(3),0x08),-3);
            st.ych_sel     = bitshift(bitand(aux(3),0x04),-2);
            st.zch_sel     = bitshift(bitand(aux(3),0x02),-1);
            st.cal_ena     = bitand(aux(3),0x01);

            st.n_block    = double(aux(4));

            st.freq_hi    = double(uint32(aux(5))*256 + uint32(aux(6)));
            st.freq_lo    = double(uint32(aux(7))*256 + uint32(aux(8)));
            st.center_freq= (st.freq_hi * 2^16 + st.freq_lo) * 9.0e4 / 2^32;  % [kHz]

            st.send_reg   = double(uint32(aux(9))*256  + uint32(aux(10)));
            if (st.send_reg>0)
                st.send_reg = st.send_reg + 1;
            end

            st.skip_reg   = double(uint32(aux(11))*256 + uint32(aux(12)));
            if (st.skip_reg>0)
                st.skip_reg = st.skip_reg + 1;
            end

            st.n_lag   = double(aux(13));

            % Temperature
            value = double(uint16(aux(14)));
            st.temp_rwi_a  = value * 2.0 - 200.0;
            value = double(uint16(aux(15)));
            st.temp_rwi_b  = value * 2.0 - 200.0;
            value = double(uint16(aux(16)));
            st.temp_hf  = value - 55.0;
     
    end

end
