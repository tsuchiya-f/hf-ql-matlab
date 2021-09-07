%-----------------------------------
% How to use hf_ccsds_ql.m
%
% Press 'q', if you want to termiante this program
%
% 1st argument : QL(1) or DL(0)
% 2nd argument : path to a CCSDS file to write(QL)/read(DL)
%
% ex)
% >> hf_ccsds_ql(1)                                QL
% >> hf_ccsds_ql(0, 'C:\share\Linux\doc\')         DL
% >> hf_ccsds_ql(1, 'C:\share\Linux\RESULTS\')     QL, HF CCSDS packets are saved in C:\share\Linux\RESULTS\HF_YYYYMMDD-HHNN.ccs 
% >> hf_ccsds_ql(0, 'C:\share\Linux\RESULTS\')     DL, Default path to a CCSDS file is set to C:\share\Linux\RESULTS\
%
% ex TSC DL)
% $ cat TMIDX_?????.bin > TMIDX_99999.bin
% >> hf_ccsds_ql(1, '', 'RPWI_HF_RFT_2021_01_26_12_10_12', '', 120)                                QL
% replay [file join /home/tsuchiya/RESULTS/RPWI_HF_FFT_2021_01_26_12_13_00 ARC TMIDX_99999.bin] -rate 100
% replay [file join /home/tsuchiya/RESULTS/RPWI_HF_RFT_2021_01_26_12_10_12 ARC TMIDX_99999.bin] -rate 100
%
%-----------------------------------

function [st_ctl] = hf_ccsds_ql(ql, st_ctl)

    %-----------------------------------
    % Default parameters, they are used if arguments are not set.
    %-----------------------------------
    % QL/DL switch (1: QL, 0:DL)
    ql=1; 
    if ~exist('ql', 'var'); ql = 1; else; ql = 0; end
    st_ctl.ql = ql;
    % Default directory of CCSDS file to read/write
    if ~isfield(st_ctl, 'dir_out'); st_ctl.dir_out = '/Users/moxon/Documents/Dropbox/private/sci/mynote/juice/hf/devel/hf-ql-matlab/data/'; end
    if strlength(st_ctl.dir_out) == 0; st_ctl.dir_out = '/Users/moxon/Documents/Dropbox/private/sci/mynote/juice/hf/devel/hf-ql-matlab/data/'; end
    if ~isfield(st_ctl, 'dir_in'); st_ctl.dir_in = '/Users/moxon/Documents/Dropbox/private/sci/mynote/juice/hf/devel/hf-ql-matlab/data/'; end
    if strlength(st_ctl.dir_in) == 0; st_ctl.dir_in = '/Users/moxon/Documents/Dropbox/private/sci/mynote/juice/hf/devel/hf-ql-matlab/data/'; end
    % Default file name (ccsds and report)
    if ~isfield(st_ctl, 'file_out'); st_ctl.file_out = ''; end
    % Default title
    if ~isfield(st_ctl, 'title'); st_ctl.title = 'HF test'; end
    % Default timeout [sec]
    if ~isfield(st_ctl, 'timeout'); st_ctl.timeout = 90; end
    if ~isfield(st_ctl, 'file_in'); st_ctl.file_in='hf_rawpacket_pssr2.bin';
    %-----------------------------------
    
    %-----------------------------------
    % Initialize structure which controls data processing
    %-----------------------------------
    [st_ctl] = hf_init_struct(st_ctl);
    
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
     fprintf('--- Output report file name : %s.pdf\n', st_ctl.file_rep);
    
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
        wait_time = st_ctl.timeout; %[sec]
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
        [st_ctl, st_rpw, st_aux, st_hfa, st_time, rdata, data_sz, err] = hf_ccsds_depacket(st_ctl);

        % check error
        if err == 1
            % --- for DL ---
            if ql == 0
                if feof(st_ctl.r) == 1; break; end
                continue;
            end
        end

        sumSize = sumSize + data_sz;
        tlm_cnt = tlm_cnt + 1;
        fprintf('SID: %02x / TLM count: %d / Data size : %d [Bytes]\n', st_rpw.sid, tlm_cnt, data_sz);

        %-----------------------------------
        % Processing & Plotting data
        %-----------------------------------
        ret = hf_plot_data(st_ctl, st_rpw, st_aux, st_hfa, st_time, rdata);
        if ret == -1
            fprintf("***** CAUTION : permanet error is detected in hf_plot_data *****\n");
            break; 
        end
        
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
