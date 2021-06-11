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
            
%             %----------------------------------------
%             % Read RPWI header (8 Bytes)
%             %----------------------------------------
%             hdr_rpw = fread(r,8,'uint8');
%             st_rpw = hf_get_hdr_rpw(hdr_rpw);
%         
%             % size of HF tlm
%             sz = st_pre.pkt_len + 1 - 20;
%             % (20Byte = sec header(10Byte) + rpwi header(8Byte) + crc(2Byte))
% 
%             hf_hdr_len = 0;
%             if st_pre.seq_flag == 1 || st_pre.seq_flag == 3
% 
%                 %----------------------------------------
%                 % Read Auxilary data
%                 %----------------------------------------
%                 % SW version
%                 if st_rpw.aux_len == 4
%                     st_ctl.ver = 1.0;
%                 else
%                     st_ctl.ver = 2.0;
%                 end
% 
%                 % read AUX field
%                 aux = cast(fread(r,st_rpw.aux_len),'uint8');
%                 sz = sz - st_rpw.aux_len;
% 
%                 %----------------------------------------
%                 % Read HF header
%                 %----------------------------------------
%                 % set HF header length
%                 if st_ctl.ver == 1.0 
%                     hf_hdr_len = 24;
%                 else
%                     if st_aux.sweep_table_id == 0xFF || st_aux.sweep_table_id == 0x1F
%                         hf_hdr_len = st_aux.hf_hdr_len;
%                     end
%                 end
%             
%                 % read HF header
%                 if hf_hdr_len ~= 0
%                     hdr_hf = fread(r,hf_hdr_len,'uint8');
%                     sz = sz - double(hf_hdr_len);
%                 else
%                     st_hfa.exist = 0;
%                 end
%             
%             end
%                 
%             %----------------------------------------
%             % Read HF data
%             %----------------------------------------
%             buff = fread(r,sz);
% 
%             %----------------------------------------
%             % Read CRC
%             %----------------------------------------
%             crc = fread(r,2);
%         
%             %----------------------------------------
%             % Write CCSDS packet to a local file
%             %----------------------------------------
%             fwrite(w, hdr_pre, 'uint8');
%             out_sz = out_sz + 6;
%             fwrite(w, hdr_sec, 'uint8');
%             out_sz = out_sz + 10;
%             fwrite(w, hdr_rpw, 'uint8');
%             if st_rpw.aux_len ~= 0 
%                 fwrite(w, aux, 'uint8');
%                 out_sz = out_sz + st_rpw.aux_len;
%             end
%             if st_pre.seq_flag == 1 || st_pre.seq_flag == 3
%                 if hf_hdr_len ~= 0
%                     fwrite(w, hdr_hf, 'uint8');
%                     out_sz = out_sz + hf_hdr_len;
%                 end
%             end
%             fwrite(w, buff, 'uint8');
%             out_sz = out_sz + sz;
%             fwrite(w, crc, 'uint8');
%             out_sz = out_sz + 2;
        
%            fprintf("SW ver: %d  SID: 0x%02x\n",st_ctl.ver, st_rpw.sid);

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
