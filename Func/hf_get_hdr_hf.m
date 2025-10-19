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
        
        st.total_step = 0;
        
        st.snum = double(uint16(bitshift(hdr(1),8)) + uint16(hdr(2)));
        st.step = double(uint16(bitshift(hdr(3),1)) + uint16(bitshift(bitand(hdr(4),0x80),-7)));
        st.decimation = double(bitshift(bitand(hdr(4),0x60),-5));
        st.pol = bitshift(bitand(hdr(4),0x10),-4);
        st.ovf_stat = bitshift(bitand(hdr(4),0x0C), -2);
        st.afsw_ver = bitand(hdr(4),0x03);
        
        st.n_band = int8(len-4)/8;
        
        if len < 5; return; end
        
        st.band0_startf = double(bitshift(hdr(5),8) + hdr(6));
        st.band0_stopf  = double(bitshift(hdr(7),8) + hdr(8));
        st.band0_step   = double(bitshift(hdr(9),8) + hdr(10));
        st.band0_rept   = double(hdr(11));
        st.band0_sdiv   = double(typecast(uint8(hdr(12)),'int8'));
        if st.band0_sdiv >= 0
            st.total_step   = st.total_step + st.band0_step * st.band0_sdiv;
        else
            st.total_step   = st.total_step + st.band0_step ./ abs(st.band0_sdiv);
        end
        if st.n_band == 1; return; end
        
        st.band1_startf = double(bitshift(hdr(13),8) + hdr(14));
        st.band1_stopf  = double(bitshift(hdr(15),8) + hdr(16));
        st.band1_step   = double(bitshift(hdr(17),8) + hdr(18));
        st.band1_rept   = double(hdr(19));
        st.band1_sdiv   = double(typecast(uint8(hdr(20)),'int8'));
        if st.band1_sdiv >= 0
            st.total_step   = st.total_step + st.band1_step * st.band1_sdiv;
        else
            st.total_step   = st.total_step + st.band1_step ./ abs(st.band1_sdiv);
        end
        if st.n_band == 2; return; end

        st.band2_startf = double(bitshift(hdr(21),8) + hdr(22));
        st.band2_stopf  = double(bitshift(hdr(23),8) + hdr(24));
        st.band2_step   = double(bitshift(hdr(25),8) + hdr(26));
        st.band2_rept   = double(hdr(27));
        st.band2_sdiv   = double(typecast(uint8(hdr(28)),'int8'));
        if st.band2_sdiv >= 0
            st.total_step   = st.total_step + st.band2_step * st.band2_sdiv;
        else
            st.total_step   = st.total_step + st.band2_step ./ abs(st.band2_sdiv);
        end
        if st.n_band == 3; return; end

        st.band3_startf = double(bitshift(hdr(29),8) + hdr(30));
        st.band3_stopf  = double(bitshift(hdr(31),8) + hdr(32));
        st.band3_step   = double(bitshift(hdr(33),8) + hdr(34));
        st.band3_rept   = double(hdr(35));
        st.band3_sdiv   = double(typecast(uint8(hdr(36)),'int8'));
        if st.band3_sdiv >= 0
            st.total_step   = st.total_step + st.band3_step * st.band3_sdiv;
        else
            st.total_step   = st.total_step + st.band3_step ./ abs(st.band3_sdiv);
        end
        if st.n_band == 4; return; end

        st.band4_startf = double(bitshift(hdr(37),8) + hdr(38));
        st.band4_stopf  = double(bitshift(hdr(39),8) + hdr(40));
        st.band4_step   = double(bitshift(hdr(41),1) + hdr(42));
        st.band4_rept   = double(hdr(43));
        st.band4_sdiv   = double(typecast(uint8(hdr(44)),'int8'));
        if st.band4_sdiv >= 0
            st.total_step   = st.total_step + st.band4_step * st.band4_sdiv;
        else
            st.total_step   = st.total_step + st.band4_step ./ abs(st.band4_sdiv);
        end
        
    end

end