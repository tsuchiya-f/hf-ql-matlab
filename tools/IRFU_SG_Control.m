% connect IRFU VPN before using this SG s\control script

% open port to NF WF1968 at IRFU
if ~exist('t','var') 
    t=tcpip('192.168.1.222',5025);
    fopen(t);
end

% check *IDN
fprintf(t,'*IDN?');
res = fscanf(t);
fprintf('%s\n',res);

% output OFF
fprintf(t,':CHAN:MODE PHAS');
fprintf(t,':OUTP1:LOAD 50OHM');
fprintf(t,':OUTP2:LOAD 50OHM');
fprintf(t,':OUTP1:STAT OFF');
fprintf(t,':OUTP2:STAT OFF');
fprintf(t,':OUTP1:SYNC:TYPE OFF');
fprintf(t,':OUTP2:SYNC:TYPE OFF');

% set freqneucy and amplitude
freq = 0.5; % MHz
mvpp = 10; % mVpp

cmd = [':SOUR:FREQ:CW ' num2str(freq) 'MHZ'];
fprintf(t,cmd);
cmd = [':SOUR1:VOLT:LEV:IMM:AMPL ' num2str(mvpp) 'MVPP'];
fprintf(t,cmd);
cmd = [':SOUR2:VOLT:LEV:IMM:AMPL ' num2str(mvpp) 'MVPP'];
fprintf(t,cmd);
cmd = [':SOUR1:SCH:VOLT:LEV:IMM:AMPL ' num2str(mvpp) 'MVPP'];
fprintf(t,cmd);

% output ON
fprintf(t,cmd);
fprintf(t,':OUTP1:STAT ON');
fprintf(t,':OUTP2:STAT ON');
fprintf(t,':OUTP1:SYNC:TYPE SFCT');

%fclose(t); clear all;