function [ret, st_ctl] = hf_get_packet(in_file, out_file)

    % Open CCSDS data file
    
    % Input file
    r = fopen(in_file,'r');
    % Output file
    if exist('out_file', 'var')
        w = fopen(out_file,'w');    
    end
    
    out_sz = 0;
    n_pkt = 0;
    ret = 0;
    cnt = 0;
    cnt_seq = 0;

    while ~feof(r)
        
        %----------------------------------------
        % Read ccsds header (6+10 Bytes)
        %----------------------------------------
        % packet primary header
        hdr_pre = fread(r, 6, 'uint8');
        % check EOF
        if size(hdr_pre) ~= 6
            break;
        end
        n_pkt = n_pkt + 1;
        st_pre = hf_get_hdr_pre(hdr_pre);

        % sequence flag (0: continue, 1: first, 2: last, 3: single)
        if st_pre.seq_flag == 1 || st_pre.seq_flag == 3
            cnt = cnt + 1;
            cnt_seq = 0;
        else
            cnt_seq = cnt_seq + 1;
        end
        
        if st_pre.err ~= 0
            fprintf("Packet error: invalid primary packet header\n");
            ret = -1;
            break;
        end

        % packet secondary header (data field header)
        hdr_sec = fread(r,10,'uint8');
        st_sec = hf_get_hdr_sec(hdr_sec);
        
%        fprintf("err:%d pus_ver:%d ser_type:%d ser_subtype:%d dest_id:%d time:0x%12x\n", st_sec.err, st_sec.pus_ver, st_sec.ser_type, st_sec.ser_subtype, st_sec.dest_id, st_sec.time);
        fprintf("cnt:%6d adu_cnt:%3d pid:0x%2x seq_flag:%d seq_cnt:%5d pkt_len:%5d pus_ver:%d ser_type:%2x ser_subtype:%d dest_id:%d time:0x%12x\n", cnt, cnt_seq, st_pre.pid, st_pre.seq_flag, st_pre.seq_cnt, st_pre.pkt_len, st_sec.pus_ver, st_sec.ser_type, st_sec.ser_subtype, st_sec.dest_id, st_sec.time);
        if st_sec.err ~= 0
            fprintf("Packet error: invalid secondary packet header\n");
            ret = -1;
            break;
        end
%        fprintf("PID: %3d  STYPE: %3d\n", st_pre.pid, st_sec.ser_type);
        
        %----------------------------------------
        % Check HF science data or not
        %----------------------------------------
        if st_pre.pid ~= 77 || st_sec.ser_type ~= 204 
            % size of data remained
            % (10Byte = sec header(10Byte))
            sz = st_pre.pkt_len + 1 - 10;
            buff = fread(r,sz);

        else
            
            ret=1;  % HF data exists.
            sz = st_pre.pkt_len + 1 - 10;
            buff = fread(r,sz);
            %----------------------------------------
            % Write CCSDS packet to a local file
            %----------------------------------------
            if exist('out_file', 'var')
                fwrite(w, hdr_pre, 'uint8');
                out_sz = out_sz + 6;
                fwrite(w, hdr_sec, 'uint8');
                out_sz = out_sz + 10;
                fwrite(w, buff, 'uint8');
                out_sz = out_sz + sz;
            end
        end
        
    end
        
    fclose(r);
    if exist('out_file', 'var')
        fclose(w);
        if out_sz == 0
            delete(out_file)
        end
    end
    
    st_ctl.n_pkt = n_pkt;
    st_ctl.out_sz = out_sz;

end
