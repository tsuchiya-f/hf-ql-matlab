%-----------------------------------
% OPEN Device (QL) or CCSDS File (DL)
%-----------------------------------
function [st_ctl] = hf_init_device(st_ctl)

     % --- for QL ---
    if st_ctl.ql == 1
        % Open TCPIP port to receive HF science temeletry via TSC (st_ctl.r)
        if ~exist('r','var')
            r = tcpip('localhost',7902);
            set(r,'InputBufferSize',2^16);
            fopen(r);
            st_ctl.r  = r;
        end
        pause(0.01)
        % Empty RX buffer
        while r.BytesAvailable>0; fread(r,r.BytesAvailable); pause(0.05); end

        % Open output file to save CCSDS packet to local computer (st_ctr.w)
        w = fopen(st_ctl.wfile,'w');
        st_ctl.w  = w;
    
        % Report file name
        st_ctl.file_rep = st_ctl.wfile;

    % --- for DL ---
    else
        % Open CCSDS data file to read (st_ctl.r)
        [file,fdir] = uigetfile([st_ctl.dir '*.*']);
        st_ctl.rfile  = fullfile(fdir,file);

        fileInfo =  dir(st_ctl.rfile);
        st_ctl.fileSize = fileInfo.bytes;
        r = fopen(st_ctl.rfile,'r');
        st_ctl.r  = r;

        % Report file name
        st_ctl.file_rep = st_ctl.rfile;
    end

end