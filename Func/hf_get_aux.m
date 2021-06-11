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
            st.raw_select  = bitshift(bitand(aux(3),0x40),-6);
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
