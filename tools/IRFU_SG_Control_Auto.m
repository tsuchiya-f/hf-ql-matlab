% connect IRFU VPN before using this SG s\control script
%fclose(t); clear all;

% set interval [sec]
interval=30;
reset = 1;

% set freqneucy(MHz), amplitude(3-ch, mVpp), and phase (3-ch, degree)
n_set = 45;
s(1) =struct('freq', 1.0,'amp_x', 10.0,'amp_y', 10.0,'amp_z', 0.0,'pha_x',  0.0,'pha_y',  0.0,'pha_z',  0.0);
s(2) =struct('freq', 2.0,'amp_x', 10.0,'amp_y', 10.0,'amp_z', 0.0,'pha_x',  0.0,'pha_y',  0.0,'pha_z',  0.0);
s(3) =struct('freq', 4.0,'amp_x', 10.0,'amp_y', 10.0,'amp_z', 0.0,'pha_x',  0.0,'pha_y',  0.0,'pha_z',  0.0);
s(4) =struct('freq', 6.0,'amp_x', 10.0,'amp_y', 10.0,'amp_z', 0.0,'pha_x',  0.0,'pha_y',  0.0,'pha_z',  0.0);
s(5) =struct('freq', 8.0,'amp_x', 10.0,'amp_y', 10.0,'amp_z', 0.0,'pha_x',  0.0,'pha_y',  0.0,'pha_z',  0.0);
s(6) =struct('freq',10.0,'amp_x', 10.0,'amp_y', 10.0,'amp_z', 0.0,'pha_x',  0.0,'pha_y',  0.0,'pha_z',  0.0);
s(7) =struct('freq',12.0,'amp_x', 10.0,'amp_y', 10.0,'amp_z', 0.0,'pha_x',  0.0,'pha_y',  0.0,'pha_z',  0.0);
s(8) =struct('freq',14.0,'amp_x', 10.0,'amp_y', 10.0,'amp_z', 0.0,'pha_x',  0.0,'pha_y',  0.0,'pha_z',  0.0);
s(9) =struct('freq',16.0,'amp_x', 10.0,'amp_y', 10.0,'amp_z', 0.0,'pha_x',  0.0,'pha_y',  0.0,'pha_z',  0.0);
s(10)=struct('freq',18.0,'amp_x', 10.0,'amp_y', 10.0,'amp_z', 0.0,'pha_x',  0.0,'pha_y',  0.0,'pha_z',  0.0);
s(11)=struct('freq',20.0,'amp_x', 10.0,'amp_y', 10.0,'amp_z', 0.0,'pha_x',  0.0,'pha_y',  0.0,'pha_z',  0.0);
s(12)=struct('freq',25.0,'amp_x', 10.0,'amp_y', 10.0,'amp_z', 0.0,'pha_x',  0.0,'pha_y',  0.0,'pha_z',  0.0);
s(13)=struct('freq',30.0,'amp_x', 10.0,'amp_y', 10.0,'amp_z', 0.0,'pha_x',  0.0,'pha_y',  0.0,'pha_z',  0.0);
s(14)=struct('freq',35.0,'amp_x', 10.0,'amp_y', 10.0,'amp_z', 0.0,'pha_x',  0.0,'pha_y',  0.0,'pha_z',  0.0);
s(15)=struct('freq',40.0,'amp_x', 10.0,'amp_y', 10.0,'amp_z', 0.0,'pha_x',  0.0,'pha_y',  0.0,'pha_z',  0.0);

s(16)=struct('freq', 1.0,'amp_x', 10.0,'amp_y', 10.0,'amp_z', 0.0,'pha_x',  90.0,'pha_y',  0.0,'pha_z',  0.0);
s(17)=struct('freq', 2.0,'amp_x', 10.0,'amp_y', 10.0,'amp_z', 0.0,'pha_x',  90.0,'pha_y',  0.0,'pha_z',  0.0);
s(18)=struct('freq', 4.0,'amp_x', 10.0,'amp_y', 10.0,'amp_z', 0.0,'pha_x',  90.0,'pha_y',  0.0,'pha_z',  0.0);
s(19)=struct('freq', 6.0,'amp_x', 10.0,'amp_y', 10.0,'amp_z', 0.0,'pha_x',  90.0,'pha_y',  0.0,'pha_z',  0.0);
s(20)=struct('freq', 8.0,'amp_x', 10.0,'amp_y', 10.0,'amp_z', 0.0,'pha_x',  90.0,'pha_y',  0.0,'pha_z',  0.0);
s(21)=struct('freq',10.0,'amp_x', 10.0,'amp_y', 10.0,'amp_z', 0.0,'pha_x',  90.0,'pha_y',  0.0,'pha_z',  0.0);
s(22)=struct('freq',12.0,'amp_x', 10.0,'amp_y', 10.0,'amp_z', 0.0,'pha_x',  90.0,'pha_y',  0.0,'pha_z',  0.0);
s(23)=struct('freq',14.0,'amp_x', 10.0,'amp_y', 10.0,'amp_z', 0.0,'pha_x',  90.0,'pha_y',  0.0,'pha_z',  0.0);
s(24)=struct('freq',16.0,'amp_x', 10.0,'amp_y', 10.0,'amp_z', 0.0,'pha_x',  90.0,'pha_y',  0.0,'pha_z',  0.0);
s(25)=struct('freq',18.0,'amp_x', 10.0,'amp_y', 10.0,'amp_z', 0.0,'pha_x',  90.0,'pha_y',  0.0,'pha_z',  0.0);
s(26)=struct('freq',20.0,'amp_x', 10.0,'amp_y', 10.0,'amp_z', 0.0,'pha_x',  90.0,'pha_y',  0.0,'pha_z',  0.0);
s(27)=struct('freq',25.0,'amp_x', 10.0,'amp_y', 10.0,'amp_z', 0.0,'pha_x',  90.0,'pha_y',  0.0,'pha_z',  0.0);
s(28)=struct('freq',30.0,'amp_x', 10.0,'amp_y', 10.0,'amp_z', 0.0,'pha_x',  90.0,'pha_y',  0.0,'pha_z',  0.0);
s(29)=struct('freq',35.0,'amp_x', 10.0,'amp_y', 10.0,'amp_z', 0.0,'pha_x',  90.0,'pha_y',  0.0,'pha_z',  0.0);
s(30)=struct('freq',40.0,'amp_x', 10.0,'amp_y', 10.0,'amp_z', 0.0,'pha_x',  90.0,'pha_y',  0.0,'pha_z',  0.0);

s(31)=struct('freq', 1.0,'amp_x', 10.0,'amp_y', 10.0,'amp_z', 0.0,'pha_x',  -90.0,'pha_y',  0.0,'pha_z',  0.0);
s(32)=struct('freq', 2.0,'amp_x', 10.0,'amp_y', 10.0,'amp_z', 0.0,'pha_x',  -90.0,'pha_y',  0.0,'pha_z',  0.0);
s(33)=struct('freq', 4.0,'amp_x', 10.0,'amp_y', 10.0,'amp_z', 0.0,'pha_x',  -90.0,'pha_y',  0.0,'pha_z',  0.0);
s(34)=struct('freq', 6.0,'amp_x', 10.0,'amp_y', 10.0,'amp_z', 0.0,'pha_x',  -90.0,'pha_y',  0.0,'pha_z',  0.0);
s(35)=struct('freq', 8.0,'amp_x', 10.0,'amp_y', 10.0,'amp_z', 0.0,'pha_x',  -90.0,'pha_y',  0.0,'pha_z',  0.0);
s(36)=struct('freq',10.0,'amp_x', 10.0,'amp_y', 10.0,'amp_z', 0.0,'pha_x',  -90.0,'pha_y',  0.0,'pha_z',  0.0);
s(37)=struct('freq',12.0,'amp_x', 10.0,'amp_y', 10.0,'amp_z', 0.0,'pha_x',  -90.0,'pha_y',  0.0,'pha_z',  0.0);
s(38)=struct('freq',14.0,'amp_x', 10.0,'amp_y', 10.0,'amp_z', 0.0,'pha_x',  -90.0,'pha_y',  0.0,'pha_z',  0.0);
s(39)=struct('freq',16.0,'amp_x', 10.0,'amp_y', 10.0,'amp_z', 0.0,'pha_x',  -90.0,'pha_y',  0.0,'pha_z',  0.0);
s(40)=struct('freq',18.0,'amp_x', 10.0,'amp_y', 10.0,'amp_z', 0.0,'pha_x',  -90.0,'pha_y',  0.0,'pha_z',  0.0);
s(41)=struct('freq',20.0,'amp_x', 10.0,'amp_y', 10.0,'amp_z', 0.0,'pha_x',  -90.0,'pha_y',  0.0,'pha_z',  0.0);
s(42)=struct('freq',25.0,'amp_x', 10.0,'amp_y', 10.0,'amp_z', 0.0,'pha_x',  -90.0,'pha_y',  0.0,'pha_z',  0.0);
s(43)=struct('freq',30.0,'amp_x', 10.0,'amp_y', 10.0,'amp_z', 0.0,'pha_x',  -90.0,'pha_y',  0.0,'pha_z',  0.0);
s(44)=struct('freq',35.0,'amp_x', 10.0,'amp_y', 10.0,'amp_z', 0.0,'pha_x',  -90.0,'pha_y',  0.0,'pha_z',  0.0);
s(45)=struct('freq',40.0,'amp_x', 10.0,'amp_y', 10.0,'amp_z', 0.0,'pha_x',  -90.0,'pha_y',  0.0,'pha_z',  0.0);

% set interval [sec]
interval=30;
reset = 1;

% set freqneucy(MHz), amplitude(3-ch, mVpp), and phase (3-ch, degree)
% n_set = 45;
% s(1) =struct('freq', 0.1,'amp_x', 10.0,'amp_y', 10.0,'amp_z', 0.0,'pha_x',  0.0,'pha_y',  0.0,'pha_z',  0.0);
% s(2) =struct('freq', 0.2,'amp_x', 10.0,'amp_y', 10.0,'amp_z', 0.0,'pha_x',  0.0,'pha_y',  0.0,'pha_z',  0.0);
% s(3) =struct('freq', 0.5,'amp_x', 10.0,'amp_y', 10.0,'amp_z', 0.0,'pha_x',  0.0,'pha_y',  0.0,'pha_z',  0.0);
% s(4) =struct('freq', 1.0,'amp_x', 10.0,'amp_y', 10.0,'amp_z', 0.0,'pha_x',  0.0,'pha_y',  0.0,'pha_z',  0.0);
% s(5) =struct('freq', 2.0,'amp_x', 10.0,'amp_y', 10.0,'amp_z', 0.0,'pha_x',  0.0,'pha_y',  0.0,'pha_z',  0.0);
% s(6) =struct('freq', 4.0,'amp_x', 10.0,'amp_y', 10.0,'amp_z', 0.0,'pha_x',  0.0,'pha_y',  0.0,'pha_z',  0.0);
% s(7) =struct('freq', 6.0,'amp_x', 10.0,'amp_y', 10.0,'amp_z', 0.0,'pha_x',  0.0,'pha_y',  0.0,'pha_z',  0.0);
% s(8) =struct('freq', 8.0,'amp_x', 10.0,'amp_y', 10.0,'amp_z', 0.0,'pha_x',  0.0,'pha_y',  0.0,'pha_z',  0.0);
% s(9) =struct('freq',10.0,'amp_x', 10.0,'amp_y', 10.0,'amp_z', 0.0,'pha_x',  0.0,'pha_y',  0.0,'pha_z',  0.0);
% s(10)=struct('freq',15.0,'amp_x', 10.0,'amp_y', 10.0,'amp_z', 0.0,'pha_x',  0.0,'pha_y',  0.0,'pha_z',  0.0);
% s(11)=struct('freq',20.0,'amp_x', 10.0,'amp_y', 10.0,'amp_z', 0.0,'pha_x',  0.0,'pha_y',  0.0,'pha_z',  0.0);
% s(12)=struct('freq',25.0,'amp_x', 10.0,'amp_y', 10.0,'amp_z', 0.0,'pha_x',  0.0,'pha_y',  0.0,'pha_z',  0.0);
% s(13)=struct('freq',30.0,'amp_x', 10.0,'amp_y', 10.0,'amp_z', 0.0,'pha_x',  0.0,'pha_y',  0.0,'pha_z',  0.0);
% s(14)=struct('freq',35.0,'amp_x', 10.0,'amp_y', 10.0,'amp_z', 0.0,'pha_x',  0.0,'pha_y',  0.0,'pha_z',  0.0);
% s(15)=struct('freq',40.0,'amp_x', 10.0,'amp_y', 10.0,'amp_z', 0.0,'pha_x',  0.0,'pha_y',  0.0,'pha_z',  0.0);
% 
% s(16)=struct('freq', 0.1,'amp_x', 10.0,'amp_y', 10.0,'amp_z', 0.0,'pha_x',  90.0,'pha_y',  0.0,'pha_z',  0.0);
% s(17)=struct('freq', 0.2,'amp_x', 10.0,'amp_y', 10.0,'amp_z', 0.0,'pha_x',  90.0,'pha_y',  0.0,'pha_z',  0.0);
% s(18)=struct('freq', 0.5,'amp_x', 10.0,'amp_y', 10.0,'amp_z', 0.0,'pha_x',  90.0,'pha_y',  0.0,'pha_z',  0.0);
% s(19)=struct('freq', 1.0,'amp_x', 10.0,'amp_y', 10.0,'amp_z', 0.0,'pha_x',  90.0,'pha_y',  0.0,'pha_z',  0.0);
% s(20)=struct('freq', 2.0,'amp_x', 10.0,'amp_y', 10.0,'amp_z', 0.0,'pha_x',  90.0,'pha_y',  0.0,'pha_z',  0.0);
% s(21)=struct('freq', 4.0,'amp_x', 10.0,'amp_y', 10.0,'amp_z', 0.0,'pha_x',  90.0,'pha_y',  0.0,'pha_z',  0.0);
% s(22)=struct('freq', 6.0,'amp_x', 10.0,'amp_y', 10.0,'amp_z', 0.0,'pha_x',  90.0,'pha_y',  0.0,'pha_z',  0.0);
% s(23)=struct('freq', 8.0,'amp_x', 10.0,'amp_y', 10.0,'amp_z', 0.0,'pha_x',  90.0,'pha_y',  0.0,'pha_z',  0.0);
% s(24)=struct('freq',10.0,'amp_x', 10.0,'amp_y', 10.0,'amp_z', 0.0,'pha_x',  90.0,'pha_y',  0.0,'pha_z',  0.0);
% s(25)=struct('freq',15.0,'amp_x', 10.0,'amp_y', 10.0,'amp_z', 0.0,'pha_x',  90.0,'pha_y',  0.0,'pha_z',  0.0);
% s(26)=struct('freq',20.0,'amp_x', 10.0,'amp_y', 10.0,'amp_z', 0.0,'pha_x',  90.0,'pha_y',  0.0,'pha_z',  0.0);
% s(27)=struct('freq',25.0,'amp_x', 10.0,'amp_y', 10.0,'amp_z', 0.0,'pha_x',  90.0,'pha_y',  0.0,'pha_z',  0.0);
% s(28)=struct('freq',30.0,'amp_x', 10.0,'amp_y', 10.0,'amp_z', 0.0,'pha_x',  90.0,'pha_y',  0.0,'pha_z',  0.0);
% s(29)=struct('freq',35.0,'amp_x', 10.0,'amp_y', 10.0,'amp_z', 0.0,'pha_x',  90.0,'pha_y',  0.0,'pha_z',  0.0);
% s(30)=struct('freq',40.0,'amp_x', 10.0,'amp_y', 10.0,'amp_z', 0.0,'pha_x',  90.0,'pha_y',  0.0,'pha_z',  0.0);
% 
% s(31)=struct('freq', 0.1,'amp_x', 10.0,'amp_y', 10.0,'amp_z', 0.0,'pha_x',  -90.0,'pha_y',  0.0,'pha_z',  0.0);
% s(32)=struct('freq', 0.2,'amp_x', 10.0,'amp_y', 10.0,'amp_z', 0.0,'pha_x',  -90.0,'pha_y',  0.0,'pha_z',  0.0);
% s(33)=struct('freq', 0.5,'amp_x', 10.0,'amp_y', 10.0,'amp_z', 0.0,'pha_x',  -90.0,'pha_y',  0.0,'pha_z',  0.0);
% s(34)=struct('freq', 1.0,'amp_x', 10.0,'amp_y', 10.0,'amp_z', 0.0,'pha_x',  -90.0,'pha_y',  0.0,'pha_z',  0.0);
% s(35)=struct('freq', 2.0,'amp_x', 10.0,'amp_y', 10.0,'amp_z', 0.0,'pha_x',  -90.0,'pha_y',  0.0,'pha_z',  0.0);
% s(36)=struct('freq', 4.0,'amp_x', 10.0,'amp_y', 10.0,'amp_z', 0.0,'pha_x',  -90.0,'pha_y',  0.0,'pha_z',  0.0);
% s(37)=struct('freq', 6.0,'amp_x', 10.0,'amp_y', 10.0,'amp_z', 0.0,'pha_x',  -90.0,'pha_y',  0.0,'pha_z',  0.0);
% s(38)=struct('freq', 8.0,'amp_x', 10.0,'amp_y', 10.0,'amp_z', 0.0,'pha_x',  -90.0,'pha_y',  0.0,'pha_z',  0.0);
% s(39)=struct('freq',10.0,'amp_x', 10.0,'amp_y', 10.0,'amp_z', 0.0,'pha_x',  -90.0,'pha_y',  0.0,'pha_z',  0.0);
% s(40)=struct('freq',15.0,'amp_x', 10.0,'amp_y', 10.0,'amp_z', 0.0,'pha_x',  -90.0,'pha_y',  0.0,'pha_z',  0.0);
% s(41)=struct('freq',20.0,'amp_x', 10.0,'amp_y', 10.0,'amp_z', 0.0,'pha_x',  -90.0,'pha_y',  0.0,'pha_z',  0.0);
% s(42)=struct('freq',25.0,'amp_x', 10.0,'amp_y', 10.0,'amp_z', 0.0,'pha_x',  -90.0,'pha_y',  0.0,'pha_z',  0.0);
% s(43)=struct('freq',30.0,'amp_x', 10.0,'amp_y', 10.0,'amp_z', 0.0,'pha_x',  -90.0,'pha_y',  0.0,'pha_z',  0.0);
% s(44)=struct('freq',35.0,'amp_x', 10.0,'amp_y', 10.0,'amp_z', 0.0,'pha_x',  -90.0,'pha_y',  0.0,'pha_z',  0.0);
% s(45)=struct('freq',40.0,'amp_x', 10.0,'amp_y', 10.0,'amp_z', 0.0,'pha_x',  -90.0,'pha_y',  0.0,'pha_z',  0.0);

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
