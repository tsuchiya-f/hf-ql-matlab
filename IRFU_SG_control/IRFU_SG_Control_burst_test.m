% connect IRFU VPN before using this SG s\control script
%fclose(t); clear all;

% set interval [sec]
interval=1;
set_amp = [10.0 10.0 0.0];
set_pha = [0.0 0.0 0.0];
n_rep = 10;

% set freqneucy(MHz), amplitude(3-ch, mVpp), and phase (3-ch, degree)
n_set = 5;
s(1)=struct('freq', 0.02,'amp_x', set_amp(1), 'amp_y', set_amp(2), 'amp_z', set_amp(3), 'pha_x',  set_pha(1), 'pha_y',  set_pha(2), 'pha_z', set_pha(3));
s(2)=struct('freq', 0.49,'amp_x', set_amp(1), 'amp_y', set_amp(2), 'amp_z', set_amp(3), 'pha_x',  set_pha(1), 'pha_y',  set_pha(2), 'pha_z', set_pha(3));
s(3)=struct('freq', 0.99,'amp_x', set_amp(1), 'amp_y', set_amp(2), 'amp_z', set_amp(3), 'pha_x',  set_pha(1), 'pha_y',  set_pha(2), 'pha_z', set_pha(3));
s(4)=struct('freq', 1.49,'amp_x', set_amp(1), 'amp_y', set_amp(2), 'amp_z', set_amp(3), 'pha_x',  set_pha(1), 'pha_y',  set_pha(2), 'pha_z', set_pha(3));
s(5)=struct('freq', 1.99,'amp_x', set_amp(1), 'amp_y', set_amp(2), 'amp_z', set_amp(3), 'pha_x',  set_pha(1), 'pha_y',  set_pha(2), 'pha_z', set_pha(3));

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

ifirst = 1;
for k = 1:n_rep
    fprintf('   %d / %d\n',k,n_rep);
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

    if ifirst == 1
         ifirst = 0;
        % output ON
        fprintf(t,cmd);
        fprintf(t,':OUTP1:STAT ON');
        fprintf(t,':OUTP2:STAT ON');
        fprintf(t,':OUTP1:SYNC:TYPE SFCT');
        fprintf('   Output ON\n');
    end
    
    pause(interval)

end
end

% output OFF
fprintf(t,':OUTP1:STAT OFF');
fprintf(t,':OUTP2:STAT OFF');
fprintf(t,':OUTP1:SYNC:TYPE OFF');
fprintf(t,':OUTP2:SYNC:TYPE OFF');

fclose(t);
clear t;

fprintf('----- Fin -----\n');
beep;pause(2);beep;pause(2);beep;
clear all;