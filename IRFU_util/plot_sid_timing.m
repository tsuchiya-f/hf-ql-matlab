

time_work_around = false; % Should be used on application software Version<=1.0


t = tcpclient('localhost', 7900);
t.Timeout = 999999;

start_time=0;

syncword = [hex2dec('EB'), hex2dec('90'), hex2dec('EB'), hex2dec('90'), hex2dec('EB'), hex2dec('90')];

prid_offset = 1;
cuc_time_offset = prid_offset + 1;
rpwi_header_offset = cuc_time_offset + 6;
sid_offset = rpwi_header_offset + 0;
delta_time_offset = rpwi_header_offset + 1;
aux_length_offset = rpwi_header_offset + 7;
aux_offset = rpwi_header_offset + 8;

process_count = 4;
process_prids = struct('LP', hex2dec('4B'), 'LF', hex2dec('4C'), 'HF', hex2dec('4D'), 'MIME', hex2dec('4E'));
prid_normalized_indexes = [hex2dec('4B'), hex2dec('4C'), hex2dec('4D'), hex2dec('4E')];

legend_indexes = ["LP", "LF", "HF", "MIME"];

rawbytes = [];
prids = cell(process_count, 1);
sids = cell(process_count, 1);
cuc_times = cell(process_count, 1);
sids_accumulated_bytes = zeros(process_count, 265);



lp_sid_to_names = ["LP Rich E763 Snapshot", "LP Survey Sweep", "LP Survey E694k", "LP Survey E24" ];
lf_sid_to_names = ["LF RAW product", "LF Rich RSWF", "LF Rich TSWF", "LF Survey DWF", "LF Survey SM", "LF Survey BP0", "LF Survey BP1", "LF Rich DSWF"];
hf_sid_to_names1 = ["HF RFT/FFT mode", "HF Survey SWEEP cycle", "HF Survey SWEEP full", "HF Burst", "HF Rich Radar mode PSSR1", "HF Rich Radar mode PSSR2", "HF Rich/Survey Radar mode PSSR3"];
hf_sid_to_names2 = ["HF SID BURST RICH","HF SID PSSR1 RICH","HF SID PSSR2 RICH","HF SID PSSR3 RICH"];    
mm_sid_to_names = ["MIME Survey Sweep mode", "MIME Survey Wide Sweep mode", "MIME Survey Tracking mode", "MIME Survey B-Field mode", "MIME Survey RFT/FFT mode", "MIME Survey Calibration mode"];

hf_sid_to_names = [hf_sid_to_names1,hf_sid_to_names2];

all_sid_to_names = [lp_sid_to_names, lf_sid_to_names, hf_sid_to_names, mm_sid_to_names];
    

close all;
figure;
hold on;

%legend();

while true
    while t.BytesAvailable == 0
        pause(0.1);
    end
    rawbytes = [rawbytes read(t, 32 * 1024)];
    skips = strfind(rawbytes, syncword);
    
    
    %disp("got " + length(rawbytes) + " bytes");
    
    for i = 1 : length(skips) - 1
        packet = rawbytes(skips(i) + length(syncword) : skips(i + 1));
        
        prid = swapbytes(typecast(uint8(packet(prid_offset)), 'uint8'));
        cuc_time_coarse_raw = packet(cuc_time_offset:cuc_time_offset+3);
        cuc_time_fine_raw = packet(cuc_time_offset+4:cuc_time_offset+4+1);
        cuc_time_coarse = swapbytes(typecast(uint8(cuc_time_coarse_raw), 'uint32'));
        cuc_time_fine = swapbytes(typecast(uint8(cuc_time_fine_raw), 'uint16'));
        
        
        
        %extract delta time
        delta_time_coarse_raw = packet(delta_time_offset:delta_time_offset+1);
        delta_time_fine_raw = packet(delta_time_offset+2:delta_time_offset+2+1);

        
        delta_time_coarse = swapbytes(typecast(uint8(delta_time_coarse_raw), 'uint16'));
        delta_time_fine = swapbytes(typecast(uint8(delta_time_fine_raw), 'uint16'));
        
        
        sid = swapbytes(typecast(uint8(packet(sid_offset)), 'uint8'));
        aux_length = swapbytes(typecast(uint8(packet(aux_length_offset)), 'uint8'));
        science_data_offset = rpwi_header_offset + 8 + aux_length;
    
        % CUC time of the package
        cuc_time_coarse=bitand(cuc_time_coarse,hex2dec('7FFFFFFF'),'uint32');
        cuc_time_pkg = double(cuc_time_coarse) + double(cuc_time_fine) / 65536;
         
        % CUC time corrected with delta -> Sample time
        cuc_time = double(cuc_time_coarse) - double(delta_time_coarse) + double(delta_time_fine)/ 65536;  
        
        pni = find(prid_normalized_indexes == prid);
        
        if(time_work_around==true)
         
        %---------------------------------------------------------------------------------
        % Workaround for HF delta time where the delta time is calculated
        % from the locat time
        
        % Filter HF data for correction
        % HF Survey SWEEP full Sid 67 needs correction
        % HF Rich Radar mode PSSR3 sid 103 is OK
        % Survey Radar mode PSSR3 Sid 71 needs correction
        if(prid == hex2dec('4D') && (sid == 71 || sid== 67))
            disp(legend_indexes(pni) + " ---- " + prid + " sid " + sid + " at " + cuc_time + " pkg time " + cuc_time_pkg + " Delta " + double(delta_time_coarse) + " fine " + (double(delta_time_fine)/ 65536));
            [cuc_time, delta_time_coarse, delta_time_fine] = TimeWorkaround_HF(sid, cuc_time_coarse, delta_time_coarse, delta_time_fine);
        end  
        
        % Workaround for LF data:
        % All dataproducts have the wrong delta time, therefore we only use
        % the package time for now
        if(prid == hex2dec('4C'))
            cuc_time=cuc_time_pkg;
            
        end
        
        % Workaround for LP:
        % E694k -> based on mem copy :    SID3 OK if overall time was OK
        % Sweep -> based on mem copy :   SID2  OK if overall time was OK
        % E763 Nominal:              SID 33     Problem
        % E24 Nominal / Burst :     SID4      Problem
        % E763 Burst:                     Might be OK
        if(prid == hex2dec('4B') && (sid == 33 || sid== 4) )
            cuc_time=cuc_time_pkg;
        end

        %---------------------------------------------------------------------------------
        end
        
            % Save first time
        if(start_time==0) start_time=cuc_time; end
        
        % Remove offset time
        cuc_time = cuc_time - start_time;
        
        
        disp(legend_indexes(pni) + " prid " + prid + " sid " + sid + " at " + cuc_time + " pkg time " + cuc_time_pkg + " Delta " + double(delta_time_coarse) + " fine " + (double(delta_time_fine)/ 65536));
        %continue;
        
        sids{pni} = [sids{pni} sid];
        cuc_times{pni} = [cuc_times{pni} cuc_time];
        science_data_length = length(packet) - double(science_data_offset);
        sids_accumulated_bytes(pni, sid + 1) = sids_accumulated_bytes(pni, sid + 1) + science_data_length;
        
        if (length(sids{pni}) < 2)
            continue;
        end
        
        previous_sid = sids{pni}(end - 1);
        previous_cuc_time = cuc_times{pni}(end - 1);
        
        if (sid == 33 && previous_sid == 4)
            % Keep E24 accumulation after E763 snapshot
            continue;
        end
        
        if (sid ~= previous_sid)
            % sid switch, don't discount data from new sid from previous sid.
            %disp("switch sid " + previous_sid + " -> " + sid);
            disp("prid " + prid + " sid " + previous_sid + " accumulated " + sids_accumulated_bytes(pni, previous_sid + 1) + " bytes");
            sids_accumulated_bytes(pni, previous_sid + 1) = 0;
        elseif (cuc_time >= previous_cuc_time + 20)
            % Same sid after some silent time, make sure to remove
            % currently appended data.
            disp("prid " + prid + " sid " + sid + " accumulated " + (sids_accumulated_bytes(pni, sid + 1) - science_data_length) + " bytes");
            sids_accumulated_bytes(pni, sid + 1) = science_data_length; % <RG> not subtract ?
        end
        %if (sid == 33 && previous_sid == 0)
        %    % Keep E24 accumulation after E763 snapshot
        %    continue;
        %end
        %if (sid ~= previous_sid)
        %    disp("sid " + previous_sid + " accumulated " + sids_accumulated_bytes(pni, previous_sid + 1) + " bytes");
        %    sids_accumulated_bytes(pni, previous_sid + 1) = 0;
        %end
        
    end
    
    rawbytes = rawbytes(skips(end):end);
    
    %disp("sids: " + length(sids));
    
    %scatter(cuc_times, sids);
    %ylim([-1, 35]);
    %drawnow;
    
    cla
    for ii = 1:length(sids)
        x = cuc_times{ii};
        %y = sids{ii};
        
        % Convert to the real sid value without the storage bits
        clean_sids = bitand(uint8(sids{ii}),0x1F);
        
        switch ii
            case 1
                % Convert to index for the name
                named_sid_idx = clean_sids;
                
                swi = find(clean_sids == 2); %Find sweep data
                
                % Time of the sweep, we use it as reference
                swt=cuc_times{ii}(swi);
                if ( length(swt)>0 )
                    for ll = 1:length(swt)
                        %xline(swt(ll),'r','HandleVisibility','off');
                        xline(swt(ll),'r');
                    end
                end
            case 2
                % Convert to index for the name
                % LF starts with sid 0, 0 is not an allowed index
                named_sid_idx = length(lp_sid_to_names) + clean_sids+1;
            case 3  
                % Display gap in SIDs properly
                idx_correct_gap=find(clean_sids>=20);
                clean_sids(idx_correct_gap)= clean_sids(idx_correct_gap)-20+length(hf_sid_to_names1)+1;
                 
                % Convert to index for the name
                named_sid_idx = length(lp_sid_to_names) + length(lf_sid_to_names) + clean_sids;           
            case 4
                % Convert to index for the name
                named_sid_idx = length(lp_sid_to_names) + length(lf_sid_to_names) + length(hf_sid_to_names) + clean_sids;
                
            otherwise
                disp('Should never happen')
        end
        
        y=named_sid_idx;

        
        plot(x, y, '.', 'MarkerSize', 15, 'DisplayName', legend_indexes(ii));
    end
    xlabel('CUC time [s]');
    ylabel('SID');
    
    set(gca,'ytick',[1:length(all_sid_to_names)],'yticklabel',all_sid_to_names)
    
  %  xline(500,'r');
    
    grid on;
    drawnow;
end


function [cuc_time, delta_time_coarse, delta_time_fine] = TimeWorkaround_HF(sid, cuc_time_coarse, delta_time_coarse, delta_time_fine)

    % for these HF sids the delta time in Version 1.0 was caluclated with
    % the local time instead of the CUC time.
    % This this codes calculates back the local time inputs, converts them
    % to CUC time and returns the corrected time for further processing
    
    fine =  bitshift(uint32(delta_time_fine),8);
    coarse = int32(bitand(cuc_time_coarse,0x7FFFFFFF,'uint32')) - int32( delta_time_coarse);

    coarse = bitcmp(coarse);
    tmp=((12500000-1)-fine);
    sec=double(coarse)+(double(tmp))*1.0/(double(12500000));
    samp_time=(sec+0.);
    samp_time_sec = fix(samp_time);
    samp_time_frac=((samp_time-samp_time_sec)*16777216.0);
    cucc = uint32(samp_time_sec);
    cucf = bitand(bitshift(uint32(samp_time_frac),-8),uint32(0xFFFF));

    % Replace the wrong values
    cuc_time = double(cucc) + double(cucf)/ 65536;

    delta_time_coarse = int32(bitand(cuc_time_coarse,0x7FFFFFFF,'uint32')) - int32(bitand(uint32(cuc_time),0x7FFFFFFF,'uint32'));
    delta_time_fine=cucf;

end