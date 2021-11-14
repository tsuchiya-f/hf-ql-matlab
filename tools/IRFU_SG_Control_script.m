% connect IRFU VPN before using this SG s\control script
%fclose(t); clear all;

% set interval [sec]
interval=10;

% set freqneucy(MHz), amplitude(3-ch, mVpp), and phase (3-ch, degree)
n_set = 3;
s(1)=struct('freq', 0.1,'amp_x', 10.0,'amp_y', 10.0,'amp_z', 10.0,'pha_x',  0.0,'pha_y',  0.0,'pha_z',  0.0);
s(2)=struct('freq', 1.0,'amp_x', 10.0,'amp_y', 10.0,'amp_z', 10.0,'pha_x',  0.0,'pha_y',  0.0,'pha_z',  0.0);
s(3)=struct('freq',10.0,'amp_x', 10.0,'amp_y', 10.0,'amp_z', 10.0,'pha_x',  0.0,'pha_y',  0.0,'pha_z',  0.0);

%--------------------------------------------------------

% open port to NF WF1968 at IRFU
if ~exist('t','var') 
%    t=tcpip('192.168.1.222',5025);
    t=visa('ni','USB0::0x0D4A::0x000E::9140149::INSTR');   %   SG (NF WF1974)
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
