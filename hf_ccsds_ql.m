%-----------------------------------
% How to use hf_ccsds_ql.m
%
% Press 'q', if you want to termiante this program
%
% 1st argument : DPU software version number ... 1.0 or other
% 2nd argument : QL(1) or DL(0)
% 3rd argument : path to a CCSDS file to write(QL)/read(DL)
%
% ex)
% >> hf_ccsds_ql(1.0, 1)                                QL for Ver.1 SW
% >> hf_ccsds_ql(1.0, 1, 'C:\share\Linux\RESULTS\')     QL for Ver.1 SW, HF CCSDS packets are saved in C:\share\Linux\RESULTS\HF_YYYYMMDD-HHNN.ccs 
% >> hf_ccsds_ql(1.0, 0, 'C:\share\Linux\RESULTS\')     DL for Ver.1 SW, Default path to a CCSDS file is set to C:\share\Linux\RESULTS\
% >> hf_ccsds_ql(2.0, 1)                                QL for Ver.2 SW
% >> hf_ccsds_ql(2.0, 0, 'C:\share\Linux\doc\')         DL for Ver.2 SW
%
% ex TSC DL)
% $ cat TMIDX_?????.bin > TMIDX_99999.bin
% >> hf_ccsds_ql(1.0, 1, '', 'RPWI_HF_RFT_2021_01_26_12_10_12', 120)                                QL for Ver.1 SW
% replay [file join /home/tsuchiya/RESULTS/RPWI_HF_FFT_2021_01_26_12_13_00 ARC TMIDX_99999.bin] -rate 100
% replay [file join /home/tsuchiya/RESULTS/RPWI_HF_RFT_2021_01_26_12_10_12 ARC TMIDX_99999.bin] -rate 100
%
%-----------------------------------

function [] = hf_ccsds_ql(ver, ql, dir_ccs, out_name, timeout)

    %-----------------------------------
    % Default parameters, they are used if arguments are not set.
    %-----------------------------------
    % HF TLM version switch (1.0 or later) 
    if ~exist('ver', 'var'); ver = 1.0; end
    % QL/DL switch (1: QL, 0:DL)
    if ~exist('ql', 'var'); ql = 1; end
    % Default directory of CCSDS file to read/write
    if ~exist('dir_ccs', 'var'); dir_ccs = 'C:\share\Linux\juice_test\'; end
    if strlength(dir_ccs) == 0; dir_ccs = 'C:\share\Linux\juice_test\'; end
    % Default output name (ccsds and report)
    if ~exist('out_name', 'var'); out_name = ''; end
    % Default timeout [sec]
    if ~exist('timeout', 'var'); timeout = 90; end
    %-----------------------------------
    
    %-----------------------------------
    % Initialize structure which controls data processing
    %-----------------------------------
    [st_ctl] = hf_init_struct(ver, ql, dir_ccs, out_name);
    
    %-----------------------------------
    % OPEN Device (QL) or CCSDS File (DL)
    % (need to do after hf_init_struct)
    %-----------------------------------
    [st_ctl] = hf_init_device(st_ctl);
    if ql == 1
        fprintf('--- Output CCSDS file name : %s\n', st_ctl.wfile);
    else
        fprintf('--- Input CCSDS file name : %s\n', st_ctl.rfile);
    end

    %-----------------------------------
    % Initialize report 
    % (need to do after hf_init_device)
    %-----------------------------------
    [st_ctl] = hf_init_report(st_ctl);
     fprintf('--- Output resport file name : %s.pdf\n', st_ctl.file_rep);
    
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
    tic;

    while true

        %-----------------------------------
        % Check elapsed time since last data received
        %-----------------------------------
        wait_time = timeout; %[sec]
        if ql == 1
            % Wait until the data is received
            % --- only for QL ---
            if st_ctl.r.BytesAvailable == 0
                elapse_time = toc;
                if tlm_cnt > 1
                    if elapse_time > wait_time; break; end
                end
                continue;
            else
                tic;
            end
        end

        %-----------------------------------
        % Get HF telemetry data
        %-----------------------------------
        [st_rpw, st_aux, st_hfa, rdata, data_sz] = hf_ccsds_depacket(st_ctl);
        sumSize = sumSize + data_sz;
        tlm_cnt = tlm_cnt + 1;
        fprintf('SID: %02x / TLM count: %d / Data size : %d [Bytes]\n', st_rpw.sid, tlm_cnt, data_sz);

        %-----------------------------------
        % Processing & Plotting data
        %-----------------------------------
        hf_plot_data(st_ctl, st_rpw, st_aux, st_hfa, rdata);

        if ql == 0
            % --- for DL ---
            pause(0.01);
            if feof(st_ctl.r) == 1; break; end
            if sumSize + data_sz > st_ctl.fileSize; break; end
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
    close(st_ctl.rpt)
    rptview(st_ctl.rpt)

    %-----------------------------------
    % Close devices
    %-----------------------------------
    fclose(st_ctl.r);
    if ql == 1; fclose(st_ctl.w); end

end
