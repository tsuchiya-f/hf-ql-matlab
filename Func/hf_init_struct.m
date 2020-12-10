%-----------------------------------
% Initialize structure which controls data processing
%-----------------------------------
function    [st_ctl] = hf_init_struct(ver, ql, dir_ccs)
    % currrent date and time (they are used to determine file names)
    ds = datestr(now, 'yyyymmdd-HHMM');
    % DPU software version number (user input)
    st_ctl.ver    = ver;
    % QL(1) or DL(0) (user input)
    st_ctl.ql     = ql;
    % Default directory of CCSDS file to read/write (user input)
    st_ctl.dir    = dir_ccs;
    % CCSDS file name to write
    st_ctl.wfile  = [st_ctl.dir 'HF_' ds '.ccs'];
end