IBS_IP = '192.168.1.171';
CFREQ=1.2e6;
decimation = 0;    %HF decimation factor 0,1,2,3
num_frames = 26;   %number of frames (with 128 samples/frame)
skip_frames = 153; %number of frames to skip +1 if non zero

FS=90e6;
FFTSZ=128*num_frames;
BW = FS/(304*2^decimation); %Bandwidth
Frange = linspace(CFREQ-BW/2,CFREQ+BW/2,FFTSZ)/1e6;

sqrt_hz = -20*log10(sqrt(BW/FFTSZ));
hfreq=typecast(uint32(round(2^32*CFREQ/FS)),'uint16');
win = window(@hann,FFTSZ)';
xft = zeros(1,FFTSZ);
yft = zeros(1,FFTSZ);
zft = zeros(1,FFTSZ);

%fileID = fopen('dump.bin','w');

%Enable writes to IP or print to screen
if 0
    if ~exist('t','var')    %Tx port
        t = tcpip(IBS_IP,8888);
        set(t,'OutputBufferSize',2^14);
        %set(t,'Timeout',30);
        fopen(t);
    end
    
    if ~exist('r','var')    %Rx port
        %pause(1.5)  %Wait for Reset RX connection
        r = tcpip(IBS_IP,8889);
        set(r,'InputBufferSize',2^18);
        fopen(r);
    end
    
    pause(0.1)  %Wait for Pi USB connection
    %fwrite(r,'FBFF000018000000');     %filter
    %fwrite(t,'W00150200');     %FPGA reset
    fwrite(t,'W00120000');     %CFG SWEEP reg
    while r.BytesAvailable>0; fread(r,r.BytesAvailable); pause(0.05); end; %Empty RX buffer
    
else
    fwrite(t,'W00120000');     %CFG SWEEP reg
    t=1;
    r=1;
end

fwrite(t,['W0010' dec2hex(hfreq(2),4)]); pause(0.0001);   %FREQ HI
fwrite(t,['W0011' dec2hex(hfreq(1),4)]); pause(0.0001);   %FREQ LO
fwrite(t,'W0016003F'); pause(0.0001);   %CFG B reg power
fwrite(t,['W001B' dec2hex(num_frames-1,4)]); pause(0.0001);   %feed frames
fwrite(t,['W001C' dec2hex(skip_frames,4)]); pause(0.0001);   %skip frames
%fwrite(t,'W00150122'); pause(0.0001);   %CFG A reg
fwrite(t,['W001501' dec2hex(2+decimation*4,1) '3']); pause(0.001);   %CFG A reg
fwrite(t,'W001AF401'); pause(0.0001);   %SPI reg (Twos complement output)
%fwrite(t,'W001AF01F'); pause(0.0001);   %SPI reg (ADC OFFSET)
%fwrite(t,'W001AED00'); pause(0.0001);   %SPI reg (ADC ouput test reg)
%fwrite(t,'W001AF8C0'); pause(0.001);   %SPI reg (ref reg)
%fwrite(t,'W001AED07'); pause(0.001);   %SPI TEST!!!!
fwrite(t,'W001AFF01'); pause(0.0001);   %SPI reg transfer data
fwrite(t,'W00120041');   %CFG SWEEP reg

inrawData = int16(zeros(1024*num_frames,1));
while 1
    %fwrite(fileID, uint8(fread(r,2052)));
    
    %Capture data
    for loop=1:1024:1024*num_frames
        header = typecast(uint8(fread(r,4)),'uint16');   %header
        %fprintf('%04X %04X %d\n', header(1), header(2), r.BytesAvailable);
        inrawData(loop:loop+1023) = typecast(uint8(fread(r,2048)),'int16');   %data
    end
    
    %     loop = 0;
    %     inrawData = [];
    %     while loop < num_frames
    %         loop = loop + 1;
    %         header = typecast(uint8(fread(r,4)),'uint16');   %header
    %         %fprintf('%d %04X %04X %d\n', loop, header(1), header(2), r.BytesAvailable);
    %         inrawData = vertcat(inrawData, uint8(fread(r,2048)));   %data
    %     end
    
    %Proccess data
    switch 1
        case 0    %1ch 20bit mode FFT
            rawData = reshape( typecast(int32(typecast(inrawData,'int16')),'uint32'), 8, []);   %data
            x=complex(double(typecast(bitor(bitshift(rawData(1,:),4), bitshift(bitand(15 ,rawData(7,:)),0) ),'int32')),...
                double(typecast(bitor(bitshift(rawData(2,:),4), bitshift(bitand(240,rawData(7,:)),-4)),'int32')) );
            %x=complex(double(typecast(bitor(bitshift(rawData(3,:),4), bitshift(bitand(3840 ,rawData(7,:)),-8) ),'int32')),...
            %          double(typecast(bitor(bitshift(rawData(4,:),4), bitshift(bitand(61440,rawData(7,:)),-12)),'int32')) );
            %x=complex(double(typecast(bitor(bitshift(rawData(5,:),4), bitshift(bitand(15 ,rawData(8,:)),-8) ),'int32')),...
            %          double(typecast(bitor(bitshift(rawData(6,:),4), bitshift(bitand(240,rawData(8,:)),-12)),'int32')) );
            %x=x-11-9.5i;   %offset max decimation
            %x=x-mean(x);   %remove offset
            %mm=mm*0.95+0.05*mean(x)
            xft=0.90*xft+0.1*abs(ifft(x.*win));
            xx=fftshift(20*(log10(0.001+xft) -log10(1.357*2^17) +0.3));
            plot(Frange, xx);
            ylim([-140 0]);
            xlim([Frange(1) Frange(end)]);
            title(['Peak dBm ' num2str(max(xx),'%0.1f')]);
            
        case 1    %3ch 20bit mode FFT
            rawData = reshape( typecast(int32(typecast(inrawData,'int16')),'uint32'), 8, []);   %data
            x=complex(double(typecast(bitor(bitshift(rawData(1,:),4), bitshift(bitand(15 ,rawData(7,:)),0) ),'int32')),...
                double(typecast(bitor(bitshift(rawData(2,:),4), bitshift(bitand(240,rawData(7,:)),-4)),'int32')) );
            y=complex(double(typecast(bitor(bitshift(rawData(3,:),4), bitshift(bitand(3840 ,rawData(7,:)),-8) ),'int32')),...
                double(typecast(bitor(bitshift(rawData(4,:),4), bitshift(bitand(61440,rawData(7,:)),-12)),'int32')) );
            z=complex(double(typecast(bitor(bitshift(rawData(5,:),4), bitshift(bitand(15 ,rawData(8,:)),-0) ),'int32')),...
                double(typecast(bitor(bitshift(rawData(6,:),4), bitshift(bitand(240,rawData(8,:)),-4)),'int32')) );
            %x=x-11-9.5i;   %offset max decimation
            %x=x-mean(x);   %remove offset
            %mm=mm*0.95+0.05*mean(x)
            xft=0.90*xft+0.1*abs(ifft(x.*win));
            yft=0.90*yft+0.1*abs(ifft(y.*win));
            zft=0.90*zft+0.1*abs(ifft(z.*win));
            xx=fftshift(20*(log10(0.001+xft) -log10(1.357*2^17) +0.3));
            yy=fftshift(20*(log10(0.001+yft) -log10(1.357*2^17) +0.3));
            zz=fftshift(20*(log10(0.001+zft) -log10(1.357*2^17) +0.3));
            plot(Frange, xx, 'r');
            hold on
            plot(Frange, yy, 'g');
            plot(Frange, zz, 'b');
            hold off
            ylim([-150 0]);
            xlim([Frange(1) Frange(end)]);
            title([num2str(max(xx),'Peak %0.1f')  num2str(max(yy),'%0.1f')  num2str(max(zz),'%0.1f dBm') ' ' num2str(FS/(304*2^decimation),'%0.0f sps') ' sqrt(Hz) ' num2str(sqrt_hz,'%0.1f') 'dB']);
            
        case 2    %20bit mode OSC
            rawData = reshape( typecast(int32(typecast(inrawData,'int16')),'uint32'), 8, []);   %data
            switch 2    %Ch X->0 Y->1 Z->2
                case 0
                    x=complex(double(typecast(bitor(bitshift(rawData(1,:),4), bitshift(bitand(15 ,rawData(7,:)),0) ),'int32')),...
                        double(typecast(bitor(bitshift(rawData(2,:),4), bitshift(bitand(240,rawData(7,:)),-4)),'int32')) );
                case 1
                    x=complex(double(typecast(bitor(bitshift(rawData(3,:),4), bitshift(bitand(3840 ,rawData(7,:)),-8) ),'int32')),...
                        double(typecast(bitor(bitshift(rawData(4,:),4), bitshift(bitand(61440,rawData(7,:)),-12)),'int32')) );
                case 2
                    x=complex(double(typecast(bitor(bitshift(rawData(5,:),4), bitshift(bitand(15 ,rawData(8,:)),0) ),'int32')),...
                        double(typecast(bitor(bitshift(rawData(6,:),4), bitshift(bitand(240,rawData(8,:)),-4)),'int32')) );
            end
            
            plot(real(x));
            hold on
            plot(imag(x),'r');
            hold off
            title([num2str(max(real(x))) ' ' num2str(min(real(x)))]);
            xlim([1 FFTSZ]);
            
        case 3    %16bit mode FFT
            rawData = reshape( typecast(inrawData,'int16'), 8, []);   %data
            x=complex(double(rawData(1,:)),double(rawData(2,:)))+0.5+0.5i;
            %x=x-mean(x);   %remove offset
            xft=0.90*xft+0.1*abs(ifft(x.*win));
            xx=fftshift(20*(log10(0.001+xft) -log10(1.357*2^13) +0.3));
            plot(xx); ylim([-120 0]);
            title(['Peak dBm ' num2str(max(xx),'%0.1f')]);
            xlim([1 FFTSZ]);
    end
    
    drawnow;
end

fwrite(t,'W00120000'); fwrite(t,'X'); fclose(r); fclose(t); clear all %CFG SWEEP reg (stop stream)

fclose(fileID);