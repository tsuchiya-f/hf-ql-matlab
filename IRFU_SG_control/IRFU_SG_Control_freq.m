% connect IRFU VPN before using this SG s\control script
%clear all;

% set interval [sec]
%interval=40;
%interval=1;
interval=3;
amp_set=10.0;
%freq_set = linspace(0.0195,45.0,500);
%freq_set = linspace(0.0195,0.3895,100);
%freq_set = [0.02 0.05 0.1 0.2 0.5 1.1 1.8 2.1 3.1 5.1 10.1 15.1 20.1 25.1 30.1 35.1 40.1 44.1]; % for RAW, Radio Full
freq_set = [0.02 0.1 0.5 1.1 1.8]; % for Radio Burst
%freq_set = [1.1 1.2 1.4 1.6 1.8]; % for PSSR1
%freq_set = [0.5 0.7 0.9 1.5 1.8 2.3 2.7 3.3 3.7 10.5 12.5 14.5 16.5 18.5 20.5 22.5];   % for PSSR2 CFG9
%freq_set = [0.31 0.51 0.71 0.91 1.11 1.51 1.91 2.31 2.71 3.11 10.51 12.51 14.51 16.51 18.51 20.51];    % for PSSR2 CFG11
%freq_set = [1.75 1.8 1.85]; % for PSSR3q
% set freqneucy(MHz), amplitude(3-ch, mVpp), and phase (3-ch, degree)
n_set = length(freq_set);
for i=1:n_set
    s(i)=struct('freq', freq_set(i), 'amp_x', amp_set, 'amp_y', amp_set, 'amp_z', amp_set, 'pha_x', 0.0, 'pha_y', 0.0, 'pha_z', 0.0);
end


%--------------------------------------------------------

% open port to NF WF1968 at IRFU
if ~exist('t','var') 
    t=tcpip('192.168.1.222',5025);
    fopen(t);

    % check *IDN
    fprintf(t,'*IDN?');
    res = fscanf(t);
    fprintf('%s',res);
end

fprintf(t,':CHAN:MODE PHAS');
fprintf(t,':OUTP1:LOAD 50OHM');
fprintf(t,':OUTP2:LOAD 50OHM');

% output OFF
fprintf(t,':OUTP1:STAT OFF');
fprintf(t,':OUTP2:STAT OFF');
fprintf(t,':OUTP1:SYNC:TYPE OFF');
fprintf(t,':OUTP2:SYNC:TYPE OFF');
fprintf('   Output OFF\n');

pause(interval)

for i = 1:n_set

    fprintf('No. %d/%d\n',i,n_set);

    % Frequency
    cmd = [':SOUR:FREQ:CW ' num2str(s(i).freq) 'MHZ'];
    fprintf(t,cmd);
    fprintf('   Set frequency %6.3f MHz\n',s(i).freq);
    
    % Amplitude
    cmd = [':SOUR1:VOLT:LEV:IMM:AMPL ' num2str(s(i).amp_x) 'MVPP'];
    fprintf(t,cmd);
    cmd = [':SOUR2:VOLT:LEV:IMM:AMPL ' num2str(s(i).amp_y) 'MVPP'];
    fprintf(t,cmd);
    cmd = [':SOUR1:SCH:VOLT:LEV:IMM:AMPL ' num2str(s(i).amp_z) 'MVPP'];
    fprintf(t,cmd);
    fprintf('   Set amplitude %6.3f/%6.3f/%6.3f mVpp\n',s(i).amp_x,s(i).amp_y,s(i).amp_z);

    % Phase
    cmd = [':SOUR1:PHAS:ADJ ' num2str(s(i).pha_x) 'DEG'];
    fprintf(t,cmd);
    cmd = [':SOUR2:PHAS:ADJ ' num2str(s(i).pha_y) 'DEG'];
    fprintf(t,cmd);
    cmd = [':SOUR1:SCH:PHAS:ADJ ' num2str(s(i).pha_z) 'DEG'];
    fprintf(t,cmd);
    fprintf('   Set phase %6.1f/%6.1f/%6.1f deg.\n',s(i).pha_x,s(i).pha_y,s(i).pha_z);

    if i == 1
        % output ON
        fprintf(t,cmd);
        fprintf(t,':OUTP1:STAT ON');
        fprintf(t,':OUTP2:STAT ON');
        fprintf(t,':OUTP1:SYNC:TYPE SFCT');
        fprintf('   Output ON\n');
    end
    
    pause(interval)

end

% output OFF
fprintf(t,':OUTP1:STAT OFF');
fprintf(t,':OUTP2:STAT OFF');
fprintf(t,':OUTP1:SYNC:TYPE OFF');
fprintf(t,':OUTP2:SYNC:TYPE OFF');
fprintf('   Output OFF\n');

fclose(t);
clear t;

pause(interval)

fprintf('----- Fin -----\n');
beep;pause(2);beep;pause(2);beep;
clear all;
