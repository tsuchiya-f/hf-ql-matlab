%----------------------------------------------------------------------------
% Delay look program for JUICE-RPWI-HF mode10 data
% Ver. 1.2
% Last update : 06/05/2020
% Author      : Fuminori Tsuchiya (TU)
%
% Update log
% 04/05/2020 Ver1.0 by F.Tsuchiya 
% 06/05/2020 Ver1.1 by F.Tsuchiya / Use enginieering value for x and y axes
% 07/05/2020 Ver1.2 by F.Tsuchiya / Update transfer function from raw to enginieering value
%
% How to use
% (1) Run HF software and set condigration 10
% (2) Run forward_hf-ccsds_to_7902.tcl on TSC
%     This script freadfers HF sciece telemetry with CCSDS header to port 7902. 
% (3) Receive HF packet from port 7902 and store the local file.
%     ex) $ nc localhost 7902 > hf_mode10.ccs 
% (4) Run this program and select "hf_mode10.ccs" as an input data
%
%----------------------------------------------------------------------------

[file,dir] = uigetfile('C:\temp\juice\data\*.ccs');
r = fopen(fullfile(dir,file),'r');

ver_str = 'HF EM';
% for rich data
fs = 296e3; % sampling rate of decimated waveform [Hz] (fixed for EM)
ns = 128;   % number of data sample in one frame (fixed)
feed = 26;  % number of feed frames in one block (fixed for EM)
skip = 154;  % number of skip frames in one block (fixed for EM)
nb = 10;    % number of block in one packet (fixed for EM)
% for survey data
nk = 3;     % number of data set (XX, YY, ZZ) (fixed for EM)

% conversion factor from ADC value to enginnering value
cf = -104.1;    % mean power of ADC value to dBm
cw = 1.46/2^20;  % ADC value to Volt

% time data
% for rich data (waveform) [sec]
tm = [];
for i=0:nb-1
    tm = [ tm, (feed+skip)*ns*i/fs + linspace(1,feed*ns,feed*ns)/fs ];
end
% for survey data (rms value) [sec]
tm_s = linspace(0,nb-1,nb)*(feed+skip)*ns/fs;

% set display layout
tiledlayout(4,1)

while true

    % exit from the loop if end-of-file is detected
    if feof(r)
        break;
    end
    
    rdata = []; % for rich data
    sdata = []; % for survey data
    rdata_sz = 0;
    sdata_sz = 0;
    while true
        % read ccsds header
        hdr_pre = fread(r,6,'uint8');
        hdr_sec = fread(r,10,'uint8');
        % read RPWI header
        hdr_rpw = fread(r,8,'uint8');
        % SID (0x67(103) for rich data, 0x47(71) for survey data)
        sid = cast(hdr_rpw(1),'uint8');
        % size of HF tlm (20B = sec header(10B) + rpwi header(8B) + crc(2B))
        sz = hdr_pre(5)*256 + hdr_pre(6) + 1 - 20;
        % sequence flag (0: conitnue, 1: first, 2: last, 3: single)
        seq_flag = bitshift(bitand(hdr_pre(3),192),-6) ; 

        %fprintf("%d %d\n",sz,seq_flag);

        % read Auxilary data
        sz_aux = hdr_rpw(8);
        if sz_aux ~= 0 
            sz = sz - sz_aux;
            aux = fread(r,sz_aux);
        end
        % read HF header
        if seq_flag == 1 || seq_flag == 3
            hdr_hf = fread(r,24,'uint8');
            sz = sz - 24;
        end
        
        % read HF data
        if sid == 103
            % rich data
            rdata = vertcat(rdata, swapbytes(typecast(uint8(fread(r,sz)),'int16')));
            rdata_sz = rdata_sz + sz;
        elseif sid == 71
            % survey data
            sdata = vertcat(sdata, cast(fread(r,sz/4,'single','ieee-be'),'single'));
            sdata_sz = sdata_sz + sz;
        end
        
        % read CRC
        crc = fread(r,2);

        % goto Plot section if end of sequence is detected
        if seq_flag == 2 || seq_flag == 3
            break;
        end
    end
    
%    disp(rdata_sz);
%    disp(sid)
    
    % Plot HF data
    if sid == 103
        % for rich data
        rdata = reshape(typecast(int32(rdata),'uint32'), 8, []);
        
        % decode waveform data
        xq = double(typecast(bitor(bitshift(rdata(1,:),4), bitshift(bitand(   15,rdata(7,:)),  0)),'int32'));
        yq = double(typecast(bitor(bitshift(rdata(3,:),4), bitshift(bitand( 3840,rdata(7,:)), -8)),'int32'));
        zq = double(typecast(bitor(bitshift(rdata(5,:),4), bitshift(bitand(   15,rdata(8,:)),  0)),'int32'));
        xi = double(typecast(bitor(bitshift(rdata(2,:),4), bitshift(bitand(  240,rdata(7,:)), -4)),'int32'));
        yi = double(typecast(bitor(bitshift(rdata(4,:),4), bitshift(bitand(61440,rdata(7,:)),-12)),'int32'));
        zi = double(typecast(bitor(bitshift(rdata(6,:),4), bitshift(bitand(  240,rdata(8,:)), -4)),'int32'));

        % convert to enginering value
        xq = xq * cw; %[Volt]
        yq = yq * cw;
        zq = zq * cw;
        xi = xi * cw;
        yi = yi * cw;
        zi = zi * cw;

        nexttile(1)
        plot(tm,xq,'r',tm,xi,'b')
        title('PSSR3 rich data X-ch Red:Xq,Blue:Xi')
        xlabel('Time [sec]')
        ylabel('ADC input [V]')

        nexttile(2)
        plot(tm,yq,'r',tm,yi,'b')
        title('PSSR3 rich data Y-ch Red:Yq,Blue:Yi')
        xlabel('Time [sec]')
        ylabel('ADC input [V]')

        nexttile(3)
        plot(tm,zq,'r',tm,zi,'b')
        title('PSSR3 rich data Z-ch Red:Zq,Blue:Zi')
        xlabel('Time [sec]')
        ylabel('ADC input [V]')

        disp('Plot rich data')
    end
    
    if sid == 71
        % for survey data
        sdata = reshape(sdata, nb, []);
        sdata = 10.0*log10(sdata) + cf;  %[dBm]

        nexttile(4)
        p=plot(tm_s,sdata);
        p(1).Color='r';
        p(2).Color='g';
        p(3).Color='b';
        title('PSSR3 survey data / Red:X, Green:Y, Blue:Z')
        xlabel('Time [sec]')
        ylabel('ADC input [dBm]')

        disp('Plot survey data')
    end
    
    disp('Hit any key to continue')
    pause

end
        
fclose(r);
