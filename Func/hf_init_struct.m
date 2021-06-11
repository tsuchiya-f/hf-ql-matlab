%-----------------------------------
% Initialize structure which controls data processing
%-----------------------------------
function    [st_ctl] = hf_init_struct(ql, dir_ccs, file_ccs, title)

    % title of test
    st_ctl.title  = title;
    % currrent date and time (they are used to determine file names)
    ds = datestr(now, 'yyyymmdd-HHMM');
    % QL(1) or DL(0) (user input)
    st_ctl.ql     = ql;
    % Default directory and file of CCSDS file to read/write (user input)
    st_ctl.dir    = dir_ccs;
    st_ctl.file   = file_ccs;
    % CCSDS file name to write
    if ql == 1 
        % QL
        if strlength(file_ccs) > 0
            st_ctl.wfile  = [st_ctl.dir 'HF_' file_ccs '.ccs'];        
        else
            st_ctl.wfile  = [st_ctl.dir 'HF_' ds '.ccs'];        
        end
    else
        % DL
%        if strlength(file_ccs) > 0
%            st_ctl.wfile  = [st_ctl.dir file_ccs];
%        else
%            st_ctl.wfile  = [st_ctl.dir 'HF_' ds '.temp'];        
%        end
    end

    % Definition of SID
    st_ctl.sid_raw     = 0x42;
    st_ctl.sid_full    = 0x43;
    st_ctl.sid_burst_s = 0x44;
    st_ctl.sid_pssr1_s = 0x45;
    st_ctl.sid_pssr2_s = 0x46;
    st_ctl.sid_pssr3_s = 0x47;
    st_ctl.sid_burst_r = 0x64;
    st_ctl.sid_pssr1_r = 0x65;
    st_ctl.sid_pssr2_r = 0x66;
    st_ctl.sid_pssr3_r = 0x67;
    
    % CUC time control
    st_ctl.first_packet = 1;

end