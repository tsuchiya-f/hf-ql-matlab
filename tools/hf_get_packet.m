function [ret, st_ctl] = hf_get_packet(in_file, out_file)

    % Open CCSDS data file
    
    % Input file
    r = fopen(in_file,'r');
    % Output file
    w = fopen(out_file,'w');
    
    out_sz = 0;
    n_pkt = 0;
    ret = 0;

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

        % packet secondary header (data field header)
        hdr_sec = fread(r,10,'uint8');
        st_sec = hf_get_hdr_sec(hdr_sec);
        
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
            fwrite(w, hdr_pre, 'uint8');
            out_sz = out_sz + 6;
            fwrite(w, hdr_sec, 'uint8');
            out_sz = out_sz + 10;
            fwrite(w, buff, 'uint8');
            out_sz = out_sz + sz;

        end
        
    end
        
    fclose(r);
    fclose(w);
    
    if out_sz == 0
        delete(out_file)
    end
    
    st_ctl.n_pkt = n_pkt;
    st_ctl.out_sz = out_sz;

end
