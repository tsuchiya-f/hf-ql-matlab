%-----------------------------------
% How to use hf_ccsds_ql.m
%
% 1st argument : DPU software version number ... 1.0 or other
% 2nd argument : QL(1) or DL(0)
% 3rd argument : path to a CCSDS file to write(QL)/read(DL)
%
% >> hf_ccsds_ql(1.0, 1)                                QL for Ver.1 SW
% >> hf_ccsds_ql(1.0, 0, 'C:\share\Linux\RESULTS\')     QL for Ver.1 SW, HF CCSDS packets are saved in C:\share\Linux\RESULTS\HF_YYYYMMDD-HHNN.ccs 
% >> hf_ccsds_ql(1.0, 0, 'C:\share\Linux\RESULTS\')     DL for Ver.1 SW, Default path to a CCSDS file is set to C:\share\Linux\RESULTS\
% >> hf_ccsds_ql(2.0, 1)                                QL for Ver.2 SW
% >> hf_ccsds_ql(2.0, 0, 'C:\share\Linux\doc\')         DL for Ver.2 SW
%-----------------------------------

function [] = hf_ccsds_ql(ver, ql, dir_ccs)

    %-----------------------------------
    % Default parameters, they are used if arguments are not set.
    %-----------------------------------
    % HF TLM version switch (1.0 or 1.1) 
    if ~exist('ver', 'var'); ver = 1.0; end
    % QL/DL switch (1: QL, 0:DL)
    if ~exist('ql', 'var'); ql = 1; end
    % Default directory
    if ~exist('dir', 'var'); dir_ccs = 'C:\share\Linux\doc\'; end
    %-----------------------------------
    
    %-----------------------------------
    % Initialize structure which controls data processing
    %-----------------------------------
    ds = datestr(now, 'yyyymmdd-HHMM');
    st_ctl.ver    = ver;
    st_ctl.ql     = ql;
    st_ctl.dir    = dir_ccs;
    st_ctl.wfile  = [st_ctl.dir 'HF_' ds '.ccs'];
    
    %-----------------------------------
    % OPEN Device (QL) or CCSDS File (DL)
    %-----------------------------------
    if st_ctl.ql == 1
        % --- for QL ---
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
        file_rep = st_ctl.wfile;
    else
        % --- for DL ---
        % Open CCSDS data file to read (st_ctl.r)
        [file,fdir] = uigetfile([st_ctl.dir '*.*']);
        st_ctl.rfile  = fullfile(fdir,file);

        fileInfo =  dir(st_ctl.rfile);
        fileSize = fileInfo.bytes;
        r = fopen(st_ctl.rfile,'r');
        st_ctl.r  = r;
        % Report file name
        file_rep = st_ctl.rfile;
    end

    %-----------------------------------
    % Initialize report
    %-----------------------------------     
    [~,name,~] = fileparts(file_rep);
    rpt = mlreportgen.report.Report(file_rep,'pdf');
    st_ctl.rpt = rpt;
    
    append(rpt, mlreportgen.report.TitlePage('Title',name))
    append(rpt, mlreportgen.report.TableOfContents)

    ch = mlreportgen.report.Chapter('Title','Test configuration');
    txt = append('DPU softare version : ', string(ver));
    append(ch, mlreportgen.dom.Text(txt));
    append(rpt, ch)

    %-----------------------------------
    % Initialize figure
    %----------------------------------- 
    hf = figure;
    st_ctl.hf = hf;
    
    %-----------------------------------
    % Read and process data
    %-----------------------------------
    sumSize = 0;
    tlm_cnt = 0;
    while true

        % --- for QL ---
        if ql == 1
            % Wait until the data is received
            if r.BytesAvailable == 0; continue; end
        end

        %-----------------------------------
        % Get HF telemetry data
        %-----------------------------------
        [st_rpw, st_aux, st_hfa, rdata, data_sz] = hf_ccsds_depacket(st_ctl);
        sumSize = sumSize + data_sz;
        tlm_cnt = tlm_cnt + 1;
        fprintf('TLM : %d / Data size : %d\n', tlm_cnt, data_sz);

        %-----------------------------------
        % Processing & Plotting data
        %-----------------------------------
        hf_plot_data(st_ctl, st_rpw, st_aux, st_hfa, rdata);

        if ql == 0
            % --- for DL ---
            pause(0.1);
            if feof(r) == 1; break; end
            if sumSize + data_sz > fileSize; break; end
        else
            % --- for QL ---
            pause(0.01);
        end

        % check the latest input from keyboard
        % if press 'q', program is terminated.
        if strcmp(get(hf,'currentcharacter'),'q')
            close(hf)
            break
        end

    end

    %-----------------------------------
    % Close report
    %----------------------------------- 
    close(rpt)
    rptview(rpt)

    %-----------------------------------
    % Close devices
    %-----------------------------------
    fclose(r);
    if ql == 1; fclose(w); end

end
