function [st] = hf_get_hdr_sec(hdr)
    
    err = 0;

    % PUS version (1)
    st.pus_ver      = bitshift(bitand(hdr(1),0x70),-4);
    if st.pus_ver ~= 1; err = err + 1; end
    % Service type (204 = 0xCC)
    st.ser_type     = hdr(2);
    if st.ser_type ~= 204; err = err + 1; end
    % Service subtype (1)
    st.ser_subtype  = hdr(3);
    if st.ser_subtype ~= 1; err = err + 1; end
    % Destination ID
    st.dest_id      = hdr(4);
    % Time
    st.time         = bitshift(hdr(5),40) ...
                    + bitshift(hdr(6),32) ...
                    + bitshift(hdr(7),24) ...
                    + bitshift(hdr(8),16) ...
                    + bitshift(hdr(9),8) ...
                    + bitshift(hdr(10),0);

    st.err = err;
    
end