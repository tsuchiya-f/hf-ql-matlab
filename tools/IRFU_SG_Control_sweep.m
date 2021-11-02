% connect IRFU VPN before using this SG control script
%fclose(t); clear all;

% set freqneucy and amplitude
start_freq = 0.2; % MHz
stop_freq  = 2.0; % MHz
swp_time   = 10;  % sec    
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

if sw == 1

    % Frequency sweep mode
    fprintf(t,':SOUR:FREQ:MODE SWE');
    fprintf(t,':SOUR:SWP:SPAC LIN');
    fprintf(t,':SOUR:SWP:INT:FUNC RAMP');

    % Frequency
    cmd = [':SOUR:FREQ:STAR ' num2str(start_freq) 'MHZ'];
    fprintf(t,cmd);
    fprintf('   Set start frequency %6.3f MHz\n',start_freq);
    cmd = [':SOUR:FREQ:STOP ' num2str(stop_freq) 'MHZ'];
    fprintf(t,cmd);
    fprintf('   Set stop frequency %6.3f MHz\n',stop_freq);
    
    cmd = [':SOUR:SWE:TIME ' num2str(swp_time) 'S'];
    fprintf(t,cmd);
    fprintf('   Set sweep time %6.3f sec\n',swp_time);
    
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
    fprintf(t,':OUTP1:STAT ON');
    fprintf(t,':OUTP2:STAT ON');
    fprintf(t,':OUTP1:SYNC:TYPE SFCT');    
    fprintf('   Output ON\n');
else
    % output OFF
    fprintf(t,':CHAN:MODE PHAS');
    fprintf(t,':OUTP1:LOAD 50OHM');
    fprintf(t,':OUTP2:LOAD 50OHM');
    fprintf(t,':OUTP1:STAT OFF');
    fprintf(t,':OUTP2:STAT OFF');
    fprintf(t,':OUTP1:SYNC:TYPE OFF');
    fprintf(t,':OUTP2:SYNC:TYPE OFF');

    % Frequency sweep mode off (CW mode)
    fprintf(t,':SOUR:FREQ:MODE CW');
    fprintf('   Output OFF\n');
end

fclose(t);
clear t;
