function [st] = hf_get_hdr_pre(hdr)

    err = 0;

    % CCSDS version number (0)
    st.ver          = bitshift(bitand(hdr(1),0xE0),-5);
    if st.ver ~= 0; err = err + 1; end
    % Packet type (0)
    st.pkt_type     = bitshift(bitand(hdr(1),0x10),-4);
    if st.pkt_type ~= 0; err = err + 1; end
    % Data field header flag (1)
    st.sec_hdr_flag = bitshift(bitand(hdr(1),0x08),-3);
    % Process ID (77=0x4D)
    st.pid          = bitshift(bitand(hdr(1),0x07),4) + bitshift(bitand(hdr(2),0xF0),-4);
    if st.pid ~= 77; err = err + 1; end
    % Packet category (12=0x0C)
    st.cat          = bitand(hdr(2),0x0F);
    if st.cat ~= 12; err = err + 1; end
    % sequence flag (0: conitnue, 1: first, 2: last, 3: single)
    st.seq_flag     = bitshift(bitand(hdr(3),0xC0),-6);
    % sequence counter
    st.seq_cnt      = bitshift(bitand(hdr(3),0x3F),8) + hdr(4);
    % packet length
    st.pkt_len      = bitshift(hdr(5),8) + hdr(6);
    
    st.err = err;

end