% connect IRFU VPN before using this SG s\control script
%fclose(t); clear all;

% set interval [sec]
interval=30;
freq_def = 1.5;
amp_def = 10;
amp_set = [1 2 5 10 20 50 100 200 500];
freq_set = [0.02 0.05 0.15 0.35 1.1 3.1 10.1 15.1 20.1 25.1 30.1 35.1 40.1 44.1];
pha_set = [0 45 90 135 180 225 270 315 0];

% set freqneucy(MHz), amplitude(3-ch, mVpp), and phase (3-ch, degree)
n_set =0;
for i=1:length(amp_set)
    n_set = n_set+1;
    s(n_set)=struct('freq', freq_def, 'amp_x', amp_set(i), 'amp_y', amp_set(i), 'amp_z', amp_set(i), 'pha_x',  0.0, 'pha_y', 0.0, 'pha_z',  0.0);
end
for i=1:n_set
    n_set = n_set+1;
    s(n_set)=struct('freq', freq_set(i), 'amp_x', amp_def, 'amp_y', amp_def, 'amp_z', amp_def, 'pha_x', 0.0, 'pha_y', 0.0, 'pha_z', 0.0);
end
for i=1:n_set
    n_set = n_set+1;
    s(n_set)=struct('freq', freq_def,'amp_x', amp_def,'amp_y', amp_def,'amp_z', amp_def,'pha_x',  pha_set(i),'pha_y',  0.0,       'pha_z',  0.0);
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

for i = 1:n_set

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

fclose(t);
clear t;
