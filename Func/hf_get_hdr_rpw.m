function [st] = hf_get_hdr_rpw(hdr)

    % SID
    st.sid        = hdr(1);
    % RPWI delta time
    st.delta_time = bitshift(hdr(2),24) ...
                  + bitshift(hdr(3),16) ...
                  + bitshift(hdr(4),8) ...
                  + bitshift(hdr(5),0);
    % Sequence counter
    st.seq_cnt    = bitshift(hdr(6),8) ...
                  + bitshift(hdr(7),0);
    % AUX length
    st.aux_len    = hdr(8);
    
%    fprintf('RPWI sequence cnt: %1d\n',st.seq_cnt);

end