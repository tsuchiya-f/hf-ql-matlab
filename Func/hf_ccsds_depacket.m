function [st_rpw, st_aux, st_hfa, rdata, data_sz] = hf_ccsds_depacket(st_ctl)

    rdata = [];
    data_sz = 0;
    
    while true
        %----------------------------------------
        % Read ccsds header (6+10 Bytes)
        %----------------------------------------
        % packet primary header
        hdr_pre = fread(st_ctl.r, 6, 'uint8');

        % packet secondary header (data field header)
        hdr_sec = fread(st_ctl.r,10,'uint8');

        st_pre = hf_get_hdr_pre(hdr_pre);
        st_sec = hf_get_hdr_sec(hdr_sec);
        
        %----------------------------------------
        % Read RPWI header (8 Bytes)
        %----------------------------------------
        hdr_rpw = fread(st_ctl.r,8,'uint8');
        st_rpw = hf_get_hdr_rpw(hdr_rpw);
        
        %----------------------------------------
        % Get time information (added to hdr_rpw)
        %----------------------------------------
        [st_rpw] = hf_get_time_info(st_ctl, st_sec, st_rpw);
        
        % size of HF tlm
        sz = st_pre.pkt_len + 1 - 20;
        % (20Byte = sec header(10Byte) + rpwi header(8Byte) + crc(2Byte))

        %----------------------------------------
        % Read Auxilary data
        %----------------------------------------
%        fprintf("Aux len : %d\n",st_rpw.aux_len);
        if st_rpw.aux_len ~= 0 
            aux = cast(fread(st_ctl.r,st_rpw.aux_len),'uint8');
            st_aux = hf_get_aux(aux, st_rpw.sid);
            sz = sz - st_rpw.aux_len;
        end

        %----------------------------------------
        % Read HF header
        %----------------------------------------
        hf_hdr_len = 0;
        if st_pre.seq_flag == 1 || st_pre.seq_flag == 3

            % set HF header length
            if st_ctl.ver == 1.0 
                hf_hdr_len = 24;
            else
                if st_aux.sweep_table_id == 255
                    hf_hdr_len = st_aux.hf_hdr_len;
                end
            end
            
            % read HF header
            if hf_hdr_len ~= 0
                hdr_hf = fread(st_ctl.r,hf_hdr_len,'uint8');
                st_hfa = hf_get_hdr_hf(hdr_hf, hf_hdr_len, st_ctl.ver);
%                fprintf("mode : %02x\n",st_hfa.mode);
                sz = sz - double(hf_hdr_len);
            else
                st_hfa.exist = 0;
            end
            
            if st_ctl.ver == 1.0 
                % add fixed AUX field & HF header for Ver1 SW 
                [st_aux, st_hfa] = hf_add_hdr_ver1(st_aux, st_hfa, st_rpw, st_ctl);
            else
                % add suuplemental infromation on tlm format 
                [st_aux, st_hfa] = hf_add_supl_info(st_aux, st_hfa, st_rpw, st_ctl);
            end

        end
        
        %----------------------------------------
        % Read HF data
        %----------------------------------------
        buff = fread(st_ctl.r,sz);
        rdata = vertcat(rdata, buff);
        data_sz = data_sz + sz;

        %----------------------------------------
        % Read CRC
        %----------------------------------------
        crc = fread(st_ctl.r,2);
        
        %----------------------------------------
        % Write CCSDS packet to a local file
        %----------------------------------------
        if st_ctl.ql == 1
            fwrite(st_ctl.w, hdr_pre, 'uint8');
            fwrite(st_ctl.w, hdr_sec, 'uint8');
            fwrite(st_ctl.w, hdr_rpw, 'uint8');
            if st_rpw.aux_len ~= 0 
            	fwrite(st_ctl.w, aux, 'uint8');
            end
            if st_pre.seq_flag == 1 || st_pre.seq_flag == 3
                if hf_hdr_len ~= 0
                    fwrite(st_ctl.w, hdr_hf, 'uint8');
                end
            end
            fwrite(st_ctl.w, buff, 'uint8');
            fwrite(st_ctl.w, crc, 'uint8');
        end
        
        %----------------------------------------
        % Exit if end of sequence is detected
        % sequence flag (0: conitnue, 1: first, 2: last, 3: single)
        %----------------------------------------
        if st_pre.seq_flag == 2 || st_pre.seq_flag == 3
            break;
        end
    end

end
