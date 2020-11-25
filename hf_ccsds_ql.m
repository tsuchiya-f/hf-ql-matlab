%-----------------------------------
% HF TLM version switch (1.0 or 1.1) 
ver = 1.1;
% QL/DL switch (1: QL, 0:DL)
ql = 1;
%-----------------------------------

%-----------------------------------
% OPEN Device or File
%-----------------------------------
if ql == 1
    % Open TCPIP port to receive HF science temeletry via TSC
    if ~exist('r','var')
        r = tcpip('localhost',7902);
        set(r,'InputBufferSize',2^16);
        fopen(r);
    end
    pause(0.01)
    % Empty RX buffer
    while r.BytesAvailable>0; fread(r,r.BytesAvailable); pause(0.05); end
else
    % Open ccsds data file
    [file,fdir] = uigetfile('C:\share\Linux\doc\*.*');
    fileInfo =  dir(fullfile(fdir,file));
    fileSize = fileInfo.bytes;
    r = fopen(fullfile(fdir,file),'r');
end

%-----------------------------------
% Read and process data
%-----------------------------------
totalSize = 0;
tlm_cnt = 0;
while true

    if ql == 1
        % Wait until the data is received
        if r.BytesAvailable == 0; continue; end
    end
    
    %-----------------------------------
    % Get HF telemetry data
    %-----------------------------------
    [st_rpw, st_aux, st_hfa, rdata, data_sz] = hf_ccsds_depacket(r, ver);
    totalSize = totalSize + data_sz;
    tlm_cnt = tlm_cnt + 1;
    fprintf('TLM:%d / Data size : %d\n', tlm_cnt, data_sz);

    %-----------------------------------
    % Processing & Plotting data
    %-----------------------------------
    ret = hf_plot_data(ver, st_rpw, st_aux, st_hfa, rdata);
    
    if ql == 0
        pause(1);
        if feof(r) == 1; break; end
        if totalSize + data_sz > fileSize; break; end
    else
        pause(0.1);
    end
    
end

fclose(r);
