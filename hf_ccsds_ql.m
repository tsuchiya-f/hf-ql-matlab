%-----------------------------------
% How to use
% >> hf_ccsds_ql(1.0, 1)       QL for Ver.1 SW
% >> hf_ccsds_ql(2.0, 1)       QL for Ver.2 SW
% >> hf_ccsds_ql(2.0, 0)       DL for Ver.2 SW
%-----------------------------------
function [] = hf_ccsds_ql(ver, ql)

    %-----------------------------------
    % HF TLM version switch (1.0 or 1.1) 
    if ~exist('ver', 'var'); ver = 1.0; end
    % QL/DL switch (1: QL, 0:DL)
    if ~exist('ql', 'var'); ql = 1; end
    %-----------------------------------
    
    ds = datestr(now, 'yyyymmdd-HHMM');
    st_ctl.ver    = ver;
    st_ctl.ql     = ql;
    st_ctl.dir    = 'C:\share\Linux\doc\';
    st_ctl.wfile  = [st_ctl.dir 'HF_' ds '.ccs'];

    %-----------------------------------
    % OPEN Device (QL) or CCSDS File (DL)
    %-----------------------------------
    if st_ctl.ql == 1
        % --- for QL ---
        % Open TCPIP port to receive HF science temeletry via TSC
        if ~exist('r','var')
            r = tcpip('localhost',7902);
            set(r,'InputBufferSize',2^16);
            fopen(r);
            w = fopen(st_ctl.wfile,'w');            
            st_ctl.r  = r;
            st_ctl.w  = w;
        end
        pause(0.01)
        % Empty RX buffer
        while r.BytesAvailable>0; fread(r,r.BytesAvailable); pause(0.05); end
    else
        % --- for DL ---
        % Open ccsds data file
        [file,fdir] = uigetfile([st_ctl.dir '*.*']);
        fileInfo =  dir(fullfile(fdir,file));
        fileSize = fileInfo.bytes;
        r = fopen(fullfile(fdir,file),'r');
        st_ctl.r  = r;
    end

    %-----------------------------------
    % Read and process data
    %-----------------------------------
    totalSize = 0;
    tlm_cnt = 0;
    while true

        % --- for QL ---
        if st_ctl.ql == 1
            % Wait until the data is received
            if r.BytesAvailable == 0; continue; end
        end

        %-----------------------------------
        % Get HF telemetry data
        %-----------------------------------
        [st_rpw, st_aux, st_hfa, rdata, data_sz] = hf_ccsds_depacket(st_ctl);
        totalSize = totalSize + data_sz;
        tlm_cnt = tlm_cnt + 1;
        fprintf('TLM : %d / Data size : %d\n', tlm_cnt, data_sz);

        %-----------------------------------
        % Processing & Plotting data
        %-----------------------------------
        ret = hf_plot_data(st_ctl.ver, st_rpw, st_aux, st_hfa, rdata);

        if st_ctl.ql == 0
            % --- for DL ---
            pause(1);
            if feof(r) == 1; break; end
            if totalSize + data_sz > fileSize; break; end
        else
            % --- for QL ---
            pause(0.1);
        end

    end

    fclose(r);
    fclose(w);

end
