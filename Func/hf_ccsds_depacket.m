function [st_rpw, st_aux, st_hfa, rdata, data_sz] = hf_ccsds_depacket(r, ver)

    rdata = [];
    data_sz = 0;

    while true
        %----------------------------------------
        % Read ccsds header (6+10 Bytes)
        %----------------------------------------
        % packet primary header
        hdr_pre = fread(r,6,'uint8');
        % packet secondary header (data field header)
        hdr_sec = fread(r,10,'uint8');
        st_pre = hf_get_hdr_pre(hdr_pre);
        st_sec = hf_get_hdr_sec(hdr_sec);
        
        %----------------------------------------
        % Read RPWI header (8 Bytes)
        %----------------------------------------
        hdr_rpw = fread(r,8,'uint8');
        st_rpw = hf_get_hdr_rpw(hdr_rpw);
        
        % size of HF tlm (20B = sec header(10B) + rpwi header(8B) + crc(2B))
        sz = st_pre.pkt_len + 1 - 20;

        %----------------------------------------
        % Read Auxilary data
        %----------------------------------------
        if st_rpw.aux_len ~= 0 
            aux = cast(fread(r,st_rpw.aux_len),'uint8');
            st_aux = hf_get_aux(aux, st_rpw.sid);
            sz = sz - st_rpw.aux_len;
        end

        %----------------------------------------
        % Read HF header
        %----------------------------------------
        hf_hdr_len = 0;
        if st_pre.seq_flag == 1 || st_pre.seq_flag == 3
            if ver == 1.0 
                hf_hdr_len = 24;
            else
                if st_aux.sweep_table_id == 255
                    hf_hdr_len = st_aux.hf_hdr_len;
                end
            end
            if hf_hdr_len ~= 0
                hdr_hf = fread(r,hf_hdr_len,'uint8');
                st_hfa = hf_get_hdr_hf(hdr_hf, hf_hdr_len, ver);
                sz = sz - double(hf_hdr_len);
            else
                st_hfa.exist = 0;
            end
        end
        
        %----------------------------------------
        % Read HF data
        %----------------------------------------
        rdata = vertcat(rdata, fread(r,sz));
        data_sz = data_sz + sz;

        %----------------------------------------
        % Read CRC
        %----------------------------------------
        crc = fread(r,2);
        
        %fprintf('sid: 0x%02x  pri_err: %d  sec_err: %d  seq_flag: %d pkt len: %d\n', st_rpw.sid, st_pre.err, st_sec.err, st_pre.seq_flag, sz);
        
        %----------------------------------------
        % Exit if end of sequence is detected
        % sequence flag (0: conitnue, 1: first, 2: last, 3: single)
        %----------------------------------------
        if st_pre.seq_flag == 2 || st_pre.seq_flag == 3
            break;
        end
    end

end

