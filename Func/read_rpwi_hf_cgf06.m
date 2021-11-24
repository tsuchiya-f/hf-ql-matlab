%----------------------------------------------------------------------------
% Read JUICE-RPWI-HF mode6 data
% Ver. 1.0
% Last update : 17/06/2020
% Author      : Fuminori Tsuchiya (TU)
%
% Update log
%
% How to use
% >> [file,dir] = uigetfile('C:\share\Linux\RESULTS\ccsds\*.ccs')
% >> [ctime, rtime, freq, fdata] = read_rwpi_hf_cfg06(fullfile(dir,file))
%
%----------------------------------------------------------------------------

function [ctime, rtime, freq, fdata] = read_rpwi_hf_cfg06(file)

    r = fopen(file,'r');

    nf = 255;  % number of frequeucy bins (fixed to be 255 for EM) 
    nk = 9;    % number of data set (fixed to be 9 for EM)
    freq = linspace(0.08, 45.0, nf);      % [MHz]

    % conversion factor from ADC value to enginnering value
    cf = -104.1;    % mean power of ADC value to dBm (for rms data)

    ieof = 0;
    ctime = [];
    rtime = [];
    rdata = [];
    while true

        data_sz = 0;
        while true
            % read ccsds header
            hdr_pre = fread(r,6,'uint8');
            hdr_sec = fread(r,10,'uint8');
            
            % exit from the loop if end-of-file is detected
            if feof(r)
                ieof=1;
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
                ctime = [ ctime, hdr_sec(1)*2^3 + hdr_sec(2)*2^2 + hdr_sec(3)*2^1 + hdr_sec(4) ];
                rtime = [ rtime, hdr_rpw(2)*2^3 + hdr_rpw(3)*2^2 + hdr_rpw(4)*2^1 + hdr_rpw(5) ];
                break;
            end
        end
        
        % exit from the loop if end-of-file is detected
        if ieof
            break;
        end
            
        if data_sz ~= cast(nf*nk*4,'int32')
            error('Invalid TLM size');
        end

    end

    fdata = 10*log10(reshape(rdata, nf, nk, [])) + cf;  % [dB]
    fclose(r);

end
