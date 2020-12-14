function [st] = hf_get_hdr_hf(hdr, len, ver)
    
    st.exist = 1;

    if ver == 1.0
        % --------------------
        % for version 1.0 SW
        % --------------------
        st.mode = hdr(1);
        return;
    else
        % --------------------
        % for later versions
        % --------------------
        st.mode = 0;
        st.snum = bitshift(hdr(1),8) + hdr(2);
        st.step = bitshift(hdr(3),8) + hdr(4);
        st.decimation = bitshift(bitand(hdr(6),0xC0),-6);
        
        st.n_band = int8(len-6)/8;
        
        st.band0_startf = bitshift(hdr(7),8) + hdr(8);
        st.band0_stopf  = bitshift(hdr(9),8) + hdr(10);
        st.band0_step   = bitshift(hdr(11),8) + hdr(12);
        st.band0_rept   = hdr(13);
        st.band0_sdiv   = hdr(14);
        if st.n_band == 1; return; end
        
        st.band1_startf = bitshift(hdr(15),8) + hdr(16);
        st.band1_stopf  = bitshift(hdr(17),8) + hdr(18);
        st.band1_step   = bitshift(hdr(19),8) + hdr(20);
        st.band1_rept   = hdr(21);
        st.band1_sdiv   = hdr(22);
        if st.n_band == 2; return; end

        st.band2_startf = bitshift(hdr(23),8) + hdr(24);
        st.band2_stopf  = bitshift(hdr(25),8) + hdr(26);
        st.band2_step   = bitshift(hdr(27),8) + hdr(28);
        st.band2_rept   = hdr(29);
        st.band2_sdiv   = hdr(30);
        if st.n_band == 3; return; end

        st.band3_startf = bitshift(hdr(31),8) + hdr(32);
        st.band3_stopf  = bitshift(hdr(33),8) + hdr(34);
        st.band3_step   = bitshift(hdr(35),8) + hdr(36);
        st.band3_rept   = hdr(37);
        st.band3_sdiv   = hdr(38);
        if st.n_band == 4; return; end

        st.band4_startf = bitshift(hdr(39),8) + hdr(40);
        st.band4_stopf  = bitshift(hdr(41),8) + hdr(42);
        st.band4_step   = bitshift(hdr(43),1) + hdr(44);
        st.band4_rept   = hdr(45);
        st.band4_sdiv   = hdr(46);
    end

end