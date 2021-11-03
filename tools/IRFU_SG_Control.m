% connect IRFU VPN before using this SG s\control script
%fclose(t); clear all;

% set freqneucy and amplitude
freq = 1.05; % MHz
mvpp = [10, 10, 10] ; % mVpp
pha  = [90.0, 0.0, 0.0] ; % deg
sw = 0;  % 1:ON, 0:OFF

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

% output OFF
fprintf(t,':CHAN:MODE PHAS');
fprintf(t,':OUTP1:LOAD 50OHM');
fprintf(t,':OUTP2:LOAD 50OHM');
fprintf(t,':OUTP1:STAT OFF');
fprintf(t,':OUTP2:STAT OFF');
fprintf(t,':OUTP1:SYNC:TYPE OFF');
fprintf(t,':OUTP2:SYNC:TYPE OFF');

if sw == 1

    % Frequency
    cmd = [':SOUR:FREQ:CW ' num2str(freq) 'MHZ'];
    fprintf(t,cmd);
    fprintf('   Set frequency %6.3f MHz\n',freq);
    
    % Amplitude
    cmd = [':SOUR1:VOLT:LEV:IMM:AMPL ' num2str(mvpp(1)) 'MVPP'];
    fprintf(t,cmd);
    cmd = [':SOUR2:VOLT:LEV:IMM:AMPL ' num2str(mvpp(2)) 'MVPP'];
    fprintf(t,cmd);
    cmd = [':SOUR1:SCH:VOLT:LEV:IMM:AMPL ' num2str(mvpp(3)) 'MVPP'];
    fprintf(t,cmd);
    fprintf('   Set amplitude %6.3f/%6.3f/%6.3f mVpp\n',mvpp(1),mvpp(2),mvpp(3));

    % Phase
    cmd = [':SOUR1:PHAS:ADJ ' num2str(pha(1)) 'DEG'];
    fprintf(t,cmd);
    cmd = [':SOUR2:PHAS:ADJ ' num2str(pha(2)) 'DEG'];
    fprintf(t,cmd);
    cmd = [':SOUR1:SCH:PHAS:ADJ ' num2str(pha(3)) 'DEG'];
    fprintf(t,cmd);
    fprintf('   Set phase %6.1f/%6.1f/%6.1f deg.\n',pha(1),pha(2),pha(3));

    % output ON
%    fprintf(t,cmd);
    fprintf(t,':OUTP1:STAT ON');
    fprintf(t,':OUTP2:STAT ON');
    fprintf(t,':OUTP1:SYNC:TYPE SFCT');
    fprintf('   Output ON\n');
else
    fprintf('   Output OFF\n');
end

fclose(t);
clear t;
