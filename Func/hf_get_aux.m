function [st] = hf_get_aux(aux,sid)

    % Sweep table ID
    st.sweep_table_id  = aux(1);
    % Channel select
    st.xch_sel     = bitshift(bitand(aux(2),0x80),-7);
    st.ych_sel     = bitshift(bitand(aux(2),0x40),-6);
    st.zch_sel     = bitshift(bitand(aux(2),0x20),-5);
    % TLM format
    st.power_sel   = bitshift(bitand(aux(2),0x10),-4);
    st.complex_sel = bitshift(bitand(aux(2),0x0C),-2);
    st.bg_subtract = bitshift(bitand(aux(2),0x02),-1);
    st.raw_select  = bitand(aux(2),0x01);

    % HF header size
    st.hf_hdr_len = double(aux(4));

end
