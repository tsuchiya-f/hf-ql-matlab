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

        return;
    end
    
    switch sid
        
        case {st_ctl.sid_raw, st_ctl.sid_full}
            % HF header size
            st.hf_hdr_len = double(bitshift(bitand(aux(1),0xF0),-4) * 4.0);
            % Channel select
            st.xch_sel     = bitshift(bitand(aux(1),0x08),-3);
            st.ych_sel     = bitshift(bitand(aux(1),0x04),-2);
            st.zch_sel     = bitshift(bitand(aux(1),0x02),-1);
            st.cal_ena     = bitand(aux(1),0x01);
            % Sweep table ID
            st.sweep_table_id  = bitshift(bitand(aux(2),0xf8),-3);
            % TLM format
            st.power_sel   = bitshift(bitand(aux(2),0x04),-2);
            st.complex_sel = bitand(aux(2),0x03);
            st.bg_subtract = bitshift(bitand(aux(3),0x80),-7);
            st.bg_select  = bitshift(bitand(aux(3),0x40),-6);
            st.fft_win     = bitshift(bitand(aux(3),0x20),-5);
            st.rfi_rej_sw  = bitshift(bitand(aux(3),0x10),-4);
            st.pol_sep_th  = bitand(aux(3),0x0f);
            st.pol_sel     = bitshift(bitand(aux(4),0xc0),-6);
            st.ovf_stat_x  = bitshift(bitand(aux(4),0x30),-4);
            st.ovf_stat_y  = bitshift(bitand(aux(4),0x0c),-2);
            st.ovf_stat_z  = bitand(aux(4),0x03);
            st.rfi_param0  = aux(5);
            st.rfi_param1  = aux(6);
            st.rfi_param2  = aux(7);
            st.rfi_param3  = aux(8);

        case {st_ctl.sid_burst_r}
            % HF header size
            st.hf_hdr_len = double(bitshift(bitand(aux(1),0xF0),-4) * 4.0);
            % Channel select
            st.xch_sel     = bitshift(bitand(aux(1),0x08),-3);
            st.ych_sel     = bitshift(bitand(aux(1),0x04),-2);
            st.zch_sel     = bitshift(bitand(aux(1),0x02),-1);
            st.cal_ena     = bitand(aux(1),0x01);
            % Sweep table ID
            st.sweep_table_id  = bitshift(bitand(aux(2),0xf8),-3);
            % TLM format
            st.power_sel   = bitshift(bitand(aux(2),0x04),-2);
            st.complex_sel = bitand(aux(2),0x03);
            st.bg_subtract = bitshift(bitand(aux(3),0x80),-7);
            st.bg_select  = bitshift(bitand(aux(3),0x40),-6);
            st.fft_win     = bitshift(bitand(aux(3),0x20),-5);
            st.rfi_rej_sw  = bitshift(bitand(aux(3),0x10),-4);
            st.pol_sep_th  = bitand(aux(3),0x0f);
            st.pol_sel     = bitshift(bitand(aux(4),0xc0),-6);
            st.ovf_stat_x  = bitshift(bitand(aux(4),0x30),-4);
            st.ovf_stat_y  = bitshift(bitand(aux(4),0x0c),-2);
            st.ovf_stat_z  = bitand(aux(4),0x03);
            st.rfi_param0  = aux(5);
            st.rfi_param1  = aux(6);
            st.rfi_param2  = aux(7);
            st.rfi_param3  = aux(8);
            st.n_block     = bitshift(aux(9), 8) + aux(10);
            spare          = bitshift(aux(11),8) + aux(12);    

        case {st_ctl.sid_pssr1_s}
            % HF header size
            st.hf_hdr_len = double(bitshift(bitand(aux(1),0xF0),-4) * 4.0);
            % Channel select
            st.xch_sel    = bitshift(bitand(aux(1),0x08),-3);
            st.ych_sel    = bitshift(bitand(aux(1),0x04),-2);
            st.zch_sel    = bitshift(bitand(aux(1),0x02),-1);
            st.cal_ena    = bitand(aux(1),0x01);
            % Sweep table ID
            st.sweep_table_id  = bitshift(bitand(aux(2),0xf8),-3);
            % TLM format
            st.start_freq = uint32(aux(5))*256 + uint32(aux(6));
            st.stop_freq  = uint32(aux(7))*256 + uint32(aux(8));
            st.sweep_step = uint32(aux(9))*256 + uint32(aux(10));
            st.interval   = bitshift(bitand(aux(3),0x7F),8) + aux(4);

        case {st_ctl.sid_pssr1_r}
            % HF header size
            st.hf_hdr_len = double(bitshift(bitand(aux(1),0xF0),-4) * 4.0);
            % Channel select
            st.xch_sel     = bitshift(bitand(aux(1),0x08),-3);
            st.ych_sel     = bitshift(bitand(aux(1),0x04),-2);
            st.zch_sel     = bitshift(bitand(aux(1),0x02),-1);
            st.cal_ena     = bitand(aux(1),0x01);
            % Sweep table ID
            st.sweep_table_id  = bitshift(bitand(aux(2),0xf8),-3);
            % TLM format
            st.power_sel   = bitshift(bitand(aux(2),0x04),-2);
            st.complex_sel = bitand(aux(2),0x03);
            st.bg_subtract = bitshift(bitand(aux(3),0x80),-7);
            st.bg_select  = bitshift(bitand(aux(3),0x40),-6);
            st.fft_win     = bitshift(bitand(aux(3),0x20),-5);
            st.rfi_rej_sw  = bitshift(bitand(aux(3),0x10),-4);
            st.pol_sep_th  = bitand(aux(3),0x0f);
            st.pol_sel     = bitshift(bitand(aux(4),0xc0),-6);
            st.ovf_stat_x  = bitshift(bitand(aux(4),0x30),-4);
            st.ovf_stat_y  = bitshift(bitand(aux(4),0x0c),-2);
            st.ovf_stat_z  = bitand(aux(4),0x03);
            st.rfi_param0  = aux(5);
            st.rfi_param1  = aux(6);
            st.rfi_param2  = aux(7);
            st.rfi_param3  = aux(8);
            st.rfi_param3  = aux(8);
            st.start_freq = uint32(aux(10))*256 + uint32(aux(9));
            
        case {st_ctl.sid_pssr2_s}
            % HF header size
            st.hf_hdr_len = double(bitshift(bitand(aux(1),0xF0),-4) * 4.0);
            % Channel select
            ant_sel       = bitshift(bitand(aux(1),0x0C),-2);
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
            st.decimation = bitshift(bitand(aux(2),0x60),-5);
            st.sweep_step = bitshift(uint32(bitand(aux(2),0x1F)),4) + bitshift(uint32(bitand(aux(3),0xF0)),-4);
            % TLM format
            st.start_freq = uint32(aux(5))*256 + uint32(aux(6));
            st.stop_freq  = uint32(aux(7))*256 + uint32(aux(8));
            st.n_sample   = uint32(aux(9))*256 + uint32(aux(10));
            st.cal_ena    = bitand(aux(1),0x01);

        case {st_ctl.sid_pssr2_r}
            % HF header size
            st.hf_hdr_len = double(bitshift(bitand(aux(1),0xF0),-4) * 4.0);
            % Channel select
            ant_sel       = bitshift(bitand(aux(1),0x0C),-2);
            st.xch_sel=0;
            st.ych_sel=0;
            st.zch_sel=0;
            if ant_sel == 0
                st.xch_sel = 1;
            elseif ant_sel == 1 
                st.ych_sel    = 1;
            elseif ant_sel == 2 
                st.zch_sel    = 1;
            else
                st.xch_sel    = 1;
            end
            st.cal_ena    = bitshift(bitand(aux(1),0x01), 0);
            st.pol_sel    = bitshift(bitand(aux(2),0x80),-7);
            st.decimation = bitshift(bitand(aux(2),0x60),-5);
            st.n_sample   = bitshift(uint32(bitand(aux(3),0xFF)),8) + bitshift(uint32(bitand(aux(4),0xFF)), 0);
            st.sweep_step = bitshift(uint32(bitand(aux(7),0xFF)),1) + bitshift(uint32(bitand(aux(8),0x80)),-7);
            % TLM format
            st.freq_sel   = uint32(aux(5))*256 + uint32(aux(6));

        case {st_ctl.sid_pssr3_s}
            % HF header size
            st.hf_hdr_len = double(bitshift(bitand(aux(1),0xF0),-4) * 4.0);
            % Channel select
            st.xch_sel    = bitshift(bitand(aux(1),0x08),-3);
            st.ych_sel    = bitshift(bitand(aux(1),0x04),-2);
            st.zch_sel    = bitshift(bitand(aux(1),0x02),-1);
            st.cal_ena    = bitand(aux(1),0x01);
            st.pol        = bitshift(bitand(aux(2),0x80),-7);
            st.decimation = bitshift(bitand(aux(2),0x60),-5);
            st.n_block    = bitshift(bitand(aux(2),0x1F),1) + bitshift(bitand(aux(3),0x80),-7);
            st.interval   = bitshift(bitand(aux(3),0x7F),8) + aux(4);
            st.n_sample   = bitshift(bitand(aux(7),0xFF),8) + bitshift(bitand(aux(8),0xFF),0);
            st.sweep_step = st.n_block;
            st.center_freq= bitshift(aux(5),8) + aux(6);

        case {st_ctl.sid_pssr3_r}
            % HF header size
            st.hf_hdr_len = double(bitshift(bitand(aux(1),0xF0),-4) * 4.0);
            % Channel select
            st.xch_sel    = bitshift(bitand(aux(1),0x08),-3);
            st.ych_sel    = bitshift(bitand(aux(1),0x04),-2);
            st.zch_sel    = bitshift(bitand(aux(1),0x02),-1);
            st.cal_ena    = bitand(aux(1),0x01);
            st.pol        = bitshift(bitand(aux(2),0x80),-7);
            st.decimation = bitshift(bitand(aux(2),0x60),-5);
            st.n_block    = double(bitshift(bitand(aux(2),0x1F),3) + bitshift(bitand(aux(3),0xE0),-5));
            st.freq_hi    = double(uint32(aux(5))*256 + uint32(aux(6)));
            st.freq_lo    = double(uint32(aux(7))*256 + uint32(aux(8)));
            st.send_reg   = double(uint32(aux(9))*256  + uint32(aux(10)));
            st.skip_reg   = double(uint32(aux(11))*256 + uint32(aux(12)));
            st.decimation = bitshift(bitand(aux(2),0x60),-5);
            
    end

%    % Sweep table ID
%    st.sweep_table_id  = aux(1);
%    % Channel select
%    st.xch_sel     = bitshift(bitand(aux(2),0x80),-7);
%    st.ych_sel     = bitshift(bitand(aux(2),0x40),-6);
%    st.zch_sel     = bitshift(bitand(aux(2),0x20),-5);
%    % TLM format
%    st.power_sel   = bitshift(bitand(aux(2),0x10),-4);
%    st.complex_sel = bitshift(bitand(aux(2),0x0C),-2);
%    st.bg_subtract = bitshift(bitand(aux(2),0x02),-1);
%    st.raw_select  = bitand(aux(2),0x01);
% 
%    % HF header size
%    st.hf_hdr_len = double(aux(4));

end
