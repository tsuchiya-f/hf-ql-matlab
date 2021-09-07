function [st_ctl, st_rpw, st_aux, st_hfa, st_time, rdata, data_sz, err] = hf_ccsds_depacket(st_ctl)

    % reset values
    rdata = [];
    data_sz = 0;
    st_rpw = 0;
    st_aux = 0;
    st_hfa = 0;
    st_time = 0;

    idx_first = 1;
    err = 0;

    while true
        
        %----------------------------------------
        % Read ccsds header (6+10 Bytes)
        %----------------------------------------
        % packet primary header
        hdr_pre = fread(st_ctl.r, 6, 'uint8');

        % check EOF
        if size(hdr_pre) ~= 6
            err = 1;
            break;
        end
        
        st_pre = hf_get_hdr_pre(hdr_pre);

        % packet secondary header (data field header)
        hdr_sec = fread(st_ctl.r,10,'uint8');
        st_sec = hf_get_hdr_sec(hdr_sec);
        
        %----------------------------------------
        % Check HF science data or not
        %----------------------------------------
        if st_pre.pid ~= 77 || st_sec.ser_type ~= 204 
            fprintf("***** CAUTION : differnt HF science packet is detected. PID(HF:77): %d  TYPE(Sci:204): %d *****\n",st_pre.pid, st_sec.ser_type);
            % size of data remained
            % (10Byte = sec header(10Byte))
            sz = st_pre.pkt_len + 1 - 10;
            buff = fread(st_ctl.r,sz);
            continue
        end
            
        %----------------------------------------------------------
        % Check sequence flag 
        % sequence flag (0: conitnue, 1: first, 2: last, 3: single)
        %----------------------------------------------------------
        if idx_first == 1 && (st_pre.seq_flag == 0 || st_pre.seq_flag == 2)
            fprintf("***** CAUTION : invalid sequence flag. The cont.(0) or last packet(2) is detected first %d\n", st_pre.seq_flag);
            % size of data remained
            % (10Byte = sec header(10Byte))
            sz = st_pre.pkt_len + 1 - 10;
            buff = fread(st_ctl.r,sz);
            continue
        end

        %----------------------------------------
        % Read RPWI header (8 Bytes)
        %----------------------------------------
        hdr_rpw = fread(st_ctl.r,8,'uint8');
        st_rpw = hf_get_hdr_rpw(hdr_rpw);
        
        % size of HF tlm
        sz = st_pre.pkt_len + 1 - 20;
        % (20Byte = sec header(10Byte) + rpwi header(8Byte) + crc(2Byte))

        hf_hdr_len = 0;
        
        %----------------------------------------------------------
        % read AUX field and HF header if first & single packet 
        % sequence flag (0: conitnue, 1: first, 2: last, 3: single)
        %----------------------------------------------------------
        if st_pre.seq_flag == 1 || st_pre.seq_flag == 3
            idx_first = 0;
            
            %----------------------------------------
            % Read Auxilary data
            %----------------------------------------
            % SW version
            if st_rpw.aux_len == 4
                st_ctl.ver = 1.0;
            else
                st_ctl.ver = 2.0;
            end
            fprintf("SW ver  : %d\n",st_ctl.ver);
            fprintf("Aux len : %d\n",st_rpw.aux_len);

            % read AUX field
            aux = cast(fread(st_ctl.r,st_rpw.aux_len),'uint8');
            st_aux = hf_get_aux(aux, st_rpw.sid, st_ctl);
            ret = hf_print_aux(st_rpw.sid, st_aux, st_ctl);
            sz = sz - st_rpw.aux_len;
            % number of available channel
            st_ctl.n_ch = st_aux.xch_sel + st_aux.ych_sel + st_aux.zch_sel;

            %----------------------------------------
            % Read HF header
            %----------------------------------------
            % set HF header length
            if st_ctl.ver == 1.0 
                hf_hdr_len = 24;
            else
%                if st_aux.sweep_table_id == 0xFF || st_aux.sweep_table_id == 0x1F
                    hf_hdr_len = st_aux.hf_hdr_len;
%                end
            end
            fprintf("HF header len : %d\n",hf_hdr_len);
            
            % read HF header
            if hf_hdr_len ~= 0
                hdr_hf = fread(st_ctl.r,hf_hdr_len,'uint8');
                st_hfa = hf_get_hdr_hf(hdr_hf, hf_hdr_len, st_ctl.ver);
                sz = sz - double(hf_hdr_len);
                ret = hf_print_hf(st_hfa, st_ctl);
            else
                st_hfa.exist = 0;
            end
            
            if st_ctl.ver == 1.0 
                % add fixed AUX field & HF header for Ver1 SW 
                [st_aux, st_hfa] = hf_add_hdr_ver1(st_aux, st_hfa, st_rpw, st_ctl);
            end

            %----------------------------------------
            % Get time information (added to hdr_rpw)
            %----------------------------------------
            [st_time, st_ctl] = hf_get_time_info(st_ctl, st_sec, st_rpw);

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
