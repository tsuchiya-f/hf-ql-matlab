% hf_decode_dl('20191211_HF_mode6.ccs',6,'em1')
function hf_decode_dl(file, mode, model)

if nargin ~= 3
    error('usage: hf_decode_dl (file, mode, model)')
end

%disp(file);
%disp(mode);
%disp(model);
dir = 'C:\temp\juice\data\201912\';
r = fopen(fullfile(dir,file),'r');

nf = 255;
nk = 9;

while true

    % detect end-of-file
    if feof(r)
        break;
    end
    
    rdata = [];
    data_sz = 0;
    while true
        % read header
        hdr_pre = fread(r,6,'uint8');
        hdr_sec = fread(r,10,'uint8');
        hdr_rpw = fread(r,8,'uint8');
        sz = hdr_pre(5)*256 + hdr_pre(6) + 1 - 20; % 20=sec header(10B) + rpwi header(8B) + crc(2B)
        seq_flag = bitshift(bitand(hdr_pre(3),192),-6) ; 
        fprintf("%d %d\n",sz,seq_flag);
        sz_aux = hdr_rpw(8);
        if sz_aux ~= 0 
            sz = sz - sz_aux;
            aux = cast(fread(r,sz_aux),'uint8');
        end
        if seq_flag == 1 || seq_flag == 3
            hdr_hf = fread(r,24,'uint8');
            sz = sz - 24;
        end
        rdata = vertcat(rdata, cast(fread(r,sz/4,'single','ieee-be'),'single'));
        data_sz = data_sz + sz;
        crc = fread(r,2);
        if seq_flag == 2 || seq_flag == 3
            break;
        end
    end
    disp(data_sz);
    if data_sz ~= cast(nf*nk*4,'int32')
        error('Invalid TLM size');
    end
    
    fdata = reshape(rdata,nf, nk);
    freq = linspace(80, 45000, nf);
    ylabels = {'XX','YY','ZZ'};
    t=stackedplot(freq,10*log10(fdata(:,1:3)),'Title','RPWI HF spectra','DisplayLabels',ylabels);
    t.AxesProperties(1).YLimits = [20 80];
    t.AxesProperties(2).YLimits = [20 80];
    t.AxesProperties(3).YLimits = [20 80];
%    semilogy(freq,fdata(:,1),freq,fdata(:,2),freq,fdata(:,3))
end

fclose(r);

end
