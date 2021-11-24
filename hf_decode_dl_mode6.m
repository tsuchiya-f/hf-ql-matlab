%----------------------------------------------------------------------------
% Delay look program for JUICE-RPWI-HF mode6 data
% Ver. 1.2
% Last update : 07/05/2020
% Author      : Fuminori Tsuchiya (TU)
%
% Update log
% 04/05/2020 Ver1.0 by F.Tsuchiya 
% 06/05/2020 Ver1.1 by F.Tsuchiya / Use enginieering value for x and y axes
% 07/05/2020 Ver1.2 by F.Tsuchiya / Update transfer function from raw to enginieering value
%
% How to use
% (1) Run HF software and set condigration 6
% (2) Run forward_hf-ccsds_to_7902.tcl on TSC
%     This script freadfers HF sciece telemetry with CCSDS header to port 7902. 
% (3) Receive HF packet from port 7902 and store the local file.
%     ex) $ nc localhost 7902 > hf_mode6.ccs 
% (4) Run this program and select "hf_mode6.ccs" as an input data
%
%----------------------------------------------------------------------------

[file,dir] = uigetfile('C:\share\Linux\RESULTS\ccsds\*.ccs');
r = fopen(fullfile(dir,file),'r');

%ver_str = 'HF EM';
ver_str = file;
nf = 255;  % number of frequeucy bins (fixed to be 255 for EM) 
nk = 9;    % number of data set (fixed to be 9 for EM)

% conversion factor from ADC value to enginnering value
cf = -104.1;    % mean power of ADC value to dBm (for rms data)

ieof = 0;
while true

    rdata = [];
    data_sz = 0;
    while true
        % read ccsds header
        hdr_pre = fread(r,6,'uint8');
        hdr_sec = fread(r,10,'uint8');

        % exit from the loop if end-of-file is detected
        if feof(r)
            ieof = 1;
            break;
        end
    
        % read RPWI header
        hdr_rpw = fread(r,8,'uint8');
        % size of HF tlm (20B = sec header(10B) + rpwi header(8B) + crc(2B))
        sz = hdr_pre(5)*256 + hdr_pre(6) + 1 - 20;
        % sequence flag (0: conitnue, 1: first, 2: last, 3: single)
        seq_flag = bitshift(bitand(hdr_pre(3),192),-6) ; 

        %fprintf("%d %d\n",sz,seq_flag);

        % read Auxilary data
        sz_aux = hdr_rpw(8);
        if sz_aux ~= 0 
            sz = sz - sz_aux;
            aux = cast(fread(r,sz_aux),'uint8');
        end
        % read HF header
        if seq_flag == 1 || seq_flag == 3
            hdr_hf = fread(r,24,'uint8');
            sz = sz - 24;
        end
        
        % read HF data
        rdata = vertcat(rdata, cast(fread(r,sz/4,'single','ieee-be'),'single'));
        data_sz = data_sz + sz;
        % read CRC
        crc = fread(r,2);
        
        % goto Plot section if end of sequence is detected
        if seq_flag == 2 || seq_flag == 3
            break;
        end
    end
 
    % exit from the loop if end-of-file is detected
    if ieof
        break;
    end
    
    %disp(data_sz);
    if data_sz ~= cast(nf*nk*4,'int32')
        error('Invalid TLM size');
    end
    fprintf('Data size : %d\n', data_sz);

    
    % Plot HF data
    fdata = 10*log10(reshape(rdata, nf, nk)) + cf;  % [dB]
    freq = linspace(0.08, 45.0, nf);      % [MHz]
    plot(freq, fdata(:,1),'r', freq, fdata(:,2),'g', freq, fdata(:,3),'b')
    xlabel ('Frequency [MHz]');
    ylabel ('Power [dBm]');

%    ylabels = {'XX [dBm]','YY [dBm]','ZZ [dBm]'};
%    t=stackedplot(freq,fdata(:,1:3),'Title',['RPWI HF spectra: ',ver_str],'DisplayLabels',ylabels);
%    xlabel ('Frequency [MHz]');
%    t.AxesProperties(1).YLimits = [-90 0];
%    t.AxesProperties(2).YLimits = [-90 0];
%    t.AxesProperties(3).YLimits = [-90 0];
%    t.LineProperties(1).Color = 'r';
%    t.LineProperties(2).Color = 'g';
%    t.LineProperties(3).Color = 'b';

    disp('Hit any key to continue');
    pause

end


fclose(r);
