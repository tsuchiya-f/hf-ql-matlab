%-----------------------------------
% Initialize structure which controls data processing
%-----------------------------------
function    [st_ctl] = hf_init_struct(st_ctl)

    % currrent date and time (they are used to determine file names)
    ds = datestr(now, 'yyyymmdd-HHMM');
    % CCSDS file name to write
    if st_ctl.ql == 1 
        % QL
        if strlength(st_ctl.file_out) > 0
            st_ctl.wfile  = append(st_ctl.dir_out, filesep, 'HF_', st_ctl.file_out, '.ccs');        
        else
            st_ctl.wfile  = append(st_ctl.dir_out, filesep, 'HF_', ds, '.ccs');        
        end
    else
        % DL
        st_ctl.wfile  = append(st_ctl.dir_in, filesep, st_ctl.file_in);
    end

    % Definition of SID
    st_ctl.sid_raw     = 0x42;
    st_ctl.sid_full    = 0x43;
    st_ctl.sid_burst_s = 0x44;
    st_ctl.sid_pssr1_s = 0x45;
    st_ctl.sid_pssr2_s = 0x46;
    st_ctl.sid_pssr3_s = 0x47;
    st_ctl.sid_burst_r = 0x74;
    st_ctl.sid_pssr1_r = 0x75;
    st_ctl.sid_pssr2_r = 0x76;
    st_ctl.sid_pssr3_r = 0x77;
    st_ctl.sid_pssr3_r_v1 = 0x67;
    
    % CUC time control
    if ~isfield(st_ctl, 'first_packet'); st_ctl.first_packet = 1; end

end