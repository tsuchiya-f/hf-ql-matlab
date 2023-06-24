%------------------------------------------------------------------------------------
% User inputs
%------------------------------------------------------------------------------------
basedir_in = "C:\share\Linux\juice_test\20230624_HF_SID2_test\";
basedir_out = "C:\share\Linux\juice_test\20230624_HF_SID2_test\out\";
mkdir(basedir_out)

% title = "HF SIS2 test, 32 samples";
% file = "HF_20230624-1132.ccs";
% n_blk=1;

% title = "HF SIS2 test, 64 samples";
% file = "HF_20230624-1139.ccs";
% n_blk=2;

title = "HF SIS2 test, 128 samples";
file = "HF_20230624-1306.ccs";
n_blk=4;
%------------------------------------------------------------------------------------

ql=0;

infile = append(basedir_in, file);
[ret, st_ctl] = hf_get_packet(infile);

st_ctl.raw_ver1_corrected = 0;
st_ctl.timeout=5;
st_ctl.ql = ql;
st_ctl.title = title;
st_ctl.ylim = [-90 -10];
st_ctl.xlim = [0 45];
st_ctl.cf = -104.1;
st_ctl.power_unit = 'dBm@ADCin';

if ret ~= 1
    fprintf("No HF data in %s\n", file);
end

fprintf("HF data in %s\n", file);
fprintf("   number of HF packet      : %d\n",st_ctl.n_pkt);  
fprintf("   number of HF data [Byte] : %d\n",st_ctl.out_sz);

st_ctl.dir_in = basedir_in;
st_ctl.dir_out = basedir_out;
st_ctl.file_in = file;

%-----------------------------------
% Initialize structure which controls data processing
%-----------------------------------
[st_ctl] = hf_init_struct(st_ctl);
hf_init_save_data;
    
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
    
sumSize = 0;
while true

    %-----------------------------------
    % Get HF telemetry data
    %-----------------------------------
    data=[];
    sz=0;
    for i=0:n_blk-1
        [st_ctl, st_rpw, st_aux, st_hfa, st_time, rdata, data_sz, err] = hf_ccsds_depacket(st_ctl);
        data = vertcat(data, rdata);
        sumSize = sumSize + data_sz;
    end

    % check error
    if err == 1
        if feof(st_ctl.r) == 1; break; end
        continue;
    end

    %-----------------------------------
    % Processing & Plotting data
    %-----------------------------------
    st_hfa.snum = (st_hfa.snum + 1) * n_blk - 1;

    ret = hf_plot_data(st_ctl, st_rpw, st_aux, st_hfa, st_time, data);
    if ret == -1
        fprintf("***** CAUTION : permanet error is detected in hf_plot_data *****\n");
        break; 
    end
        
    if feof(st_ctl.r) == 1; break; end
    if sumSize + sz > st_ctl.fileSize; break; end
        
end
    
%-----------------------------------
% Close report
%----------------------------------- 
close(hf)
close(st_ctl.rpt)
rptview(st_ctl.rpt)

%-----------------------------------
% Close devices
%-----------------------------------
fclose(st_ctl.r);


