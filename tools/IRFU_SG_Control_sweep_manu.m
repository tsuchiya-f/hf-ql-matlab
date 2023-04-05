% connect IRFU VPN before using this SG s\control script
%fclose(t); 
clear all;

% set interval [sec]
interval=2;
reset = 1;

% set freqneucy(MHz), amplitude(3-ch, mVpp), and phase (3-ch, degree)
ii=1;
for i=1:20
    s(ii) =struct('freq', i/10.0, 'amp_x', 10.0,'amp_y', 10.0,'amp_z', 10.0,'pha_x',  0.0,'pha_y',  0.0,'pha_z',  0.0);
    ii=ii+1;
end
for i=1:20
    s(ii) =struct('freq', i/10.0, 'amp_x', 10.0,'amp_y', 10.0,'amp_z', 10.0,'pha_x',  90.0,'pha_y',  0.0,'pha_z',  0.0);
    ii=ii+1;
end
for i=1:20
    s(ii) =struct('freq', i/10.0, 'amp_x', 10.0,'amp_y', 10.0,'amp_z', 10.0,'pha_x',  0.0,'pha_y',  90.0,'pha_z',  0.0);
    ii=ii+1;
end
for i=1:20
    s(ii) =struct('freq', i/10.0, 'amp_x', 10.0,'amp_y', 10.0,'amp_z', 10.0,'pha_x',  0.0,'pha_y',  0.0,'pha_z',  90.0);
    ii=ii+1;
end
n_set = numel(s);

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

if reset == 1
    fprintf(t,'*RST');
    pause(3);
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
fprintf('   Output OFF\n');

fclose(t);
clear t;
