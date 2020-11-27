% How to use
% (1) Run HF software and set condigration 0
%     this script assume HF FPGA WREG settings as follows
%     - num_sampl = 32; %number of samples at each frequency step
%     - num_steps = 512;  %number of frequency steps
% (2) Run forward_hf_to_7902.tcl on TSC
%     This script freadfers HF sciece telemetry without CCSDS header to port 7902. 
% (3) Run this program

STARTF = 0.08e6;    % start frequency
STOPF = 45.0e6;     % stop frequency
FS = 90e6;  %sample frequency
num_sampl = 32; %number of samples at each frequency step
num_steps = 512;  %number of frequency steps
freq = linspace(STARTF, STOPF, num_steps);
steps = uint32(2^32*freq/FS);
steps = reshape(typecast(steps,'uint16'),2,[]);

if ~exist('r','var')
    r = tcpip('localhost',7902);
    set(r,'InputBufferSize',2^16);
    fopen(r);
end

pause(0.01)
while r.BytesAvailable>0; fread(r,r.BytesAvailable); pause(0.05); end %Empty RX buffer

while true
    
    if r.BytesAvailable==0; continue; end
    
    %Capture data
    loop = 0;
    rawData = [];
    hf_header = uint8(fread(r,24));   %header
    while loop < ceil(num_sampl*num_steps/128)
        loop = loop + 1;
%        header = typecast(uint8(fread(r,4)),'uint16');   %header
%        fprintf('%d %04X %04X %d\n', loop, header(1), header(2), r.BytesAvailable);
%        fprintf('%d %d\n', loop, r.BytesAvailable);
%        rawData = vertcat(rawData, typecast(uint8(fread(r,2048)),'int16'));   %data
%        rawData = vertcat(rawData, typecast(uint8(fread(r,2048)),'int16'));   %data
        rawData = vertcat(rawData, swapbytes(typecast(uint8(fread(r,2048)),'int16')));   %dataswapbytes
    end
    
    
    %Plot data
    %3ch True RMS with correct dBm scaling 20bit mode old matlab
    rawData = reshape(typecast(int32(rawData),'uint32'), 8, []);
%     x=complex(double(typecast(bitor(bitshift(rawData(1,:),4), bitshift(bitand(15 ,rawData(7,:)),0) ),'int32')),...
%               double(typecast(bitor(bitshift(rawData(2,:),4), bitshift(bitand(240,rawData(7,:)),-4)),'int32')) );
%     y=complex(double(typecast(bitor(bitshift(rawData(3,:),4), bitshift(bitand(3840 ,rawData(7,:)),-8) ),'int32')),...
%               double(typecast(bitor(bitshift(rawData(4,:),4), bitshift(bitand(61440,rawData(7,:)),-12)),'int32')) );
%     z=complex(double(typecast(bitor(bitshift(rawData(5,:),4), bitshift(bitand(15 ,rawData(8,:)),0) ),'int32')),...
%               double(typecast(bitor(bitshift(rawData(6,:),4), bitshift(bitand(240,rawData(8,:)),-4)),'int32')) );
      
    xq = reshape( double(typecast(bitor(bitshift(rawData(1,:),4), bitshift(bitand(   15,rawData(7,:)),  0)),'int32')), [num_sampl, num_steps]);
    yq = reshape( double(typecast(bitor(bitshift(rawData(3,:),4), bitshift(bitand( 3840,rawData(7,:)), -8)),'int32')), [num_sampl, num_steps]);
    zq = reshape( double(typecast(bitor(bitshift(rawData(5,:),4), bitshift(bitand(   15,rawData(8,:)),  0)),'int32')), [num_sampl, num_steps]);
    xi = reshape( double(typecast(bitor(bitshift(rawData(2,:),4), bitshift(bitand(  240,rawData(7,:)), -4)),'int32')), [num_sampl, num_steps]);
    yi = reshape( double(typecast(bitor(bitshift(rawData(4,:),4), bitshift(bitand(61440,rawData(7,:)),-12)),'int32')), [num_sampl, num_steps]);
    zi = reshape( double(typecast(bitor(bitshift(rawData(6,:),4), bitshift(bitand(  240,rawData(8,:)), -4)),'int32')), [num_sampl, num_steps]);

    cnt = bitshift(bitand(  768,rawData(8,:)), -8);     % 2bit  0000 0011 0000 0000  0x0300=768
    swp = bitshift(bitand( 1024,rawData(8,:)),-10);     % 1bit  0000 0100 0000 0000  0x0400=1024
    dec = bitshift(bitand( 6144,rawData(8,:)),-11);     % 2bit  0001 1000 0000 0000  0x1800=6144
    ovf = bitshift(bitand(57344,rawData(8,:)),-13);     % 3bit  1110 0000 0000 0000  0xE000=57344
    fprintf('sweep:%d-%d cnt:%d dec:%d ovf:%d\n', swp(1),swp(2),cnt(1),dec(1),ovf(1));

    % auto correlation
    Xabs = sqrt( mean( xq.^2+xi.^2, 1 ) );
    Yabs = sqrt( mean( yq.^2+yi.^2, 1 ) );
    Zabs = sqrt( mean( zq.^2+zi.^2, 1 ) );
    X = 20 * ( log10( Xabs ) - log10( 1.357 * 2^17 ) ) + 0.9;
    Y = 20 * ( log10( Yabs ) - log10( 1.357 * 2^17 ) ) + 0.9;
    Z = 20 * ( log10( Zabs ) - log10( 1.357 * 2^17 ) ) + 0.9;       
          
    %X=20*(log10(max(sqrt(mean(reshape(abs(x(1:num_sampl*num_steps)).^2,num_sampl,[]),1)),0.1)) -log10(1.357*2^17) );
    plot(linspace(STARTF,STOPF,num_steps)/1e6, X,'r')%%%%1102
    %plot(linspace(STARTF,STOPF,num_steps)/1e6, rad2deg(mean(reshape((angle(x(1:num_sampl*num_steps))),num_sampl,[]),1)),'r');
    hold on
    %Y=20*(log10(max(sqrt(mean(reshape(abs(y(1:num_sampl*num_steps)).^2,num_sampl,[]),1)),0.1)) -log10(1.357*2^17) );
    plot(linspace(STARTF,STOPF,num_steps)/1e6, Y,'g')%%%%1102
    %plot(linspace(STARTF,STOPF,num_steps)/1e6, rad2deg(mean(reshape((angle(y(1:num_sampl*num_steps))),num_sampl,[]),1)),'g');
            
    %Z=20*(log10(max(sqrt(mean(reshape(abs(z(1:num_sampl*num_steps)).^2,num_sampl,[]),1)),0.1)) -log10(1.357*2^17) );
    plot(linspace(STARTF,STOPF,num_steps)/1e6, Z,'b')%%%%1102
    %plot(linspace(STARTF,STOPF,num_steps)/1e6, rad2deg(mean(reshape((angle(z(1:num_sampl*num_steps))),num_sampl,[]),1)),'b');
    %%Show -6dB from full scale detection (~405mVpp)
    plot(linspace(STARTF,STOPF,num_steps)/1e6, mean(reshape(bitand(7,bitshift(rawData(8,1:num_sampl*num_steps),-13)),num_sampl,[]),1),'g')%%%%1102
            
    hold off
    %xlim([STARTF/1e6 STOPF/1e6]);
    %ylim([-100 10]);%%%%1102
    %title(['Peak Blue[' num2str(max(X),'%0.1f') '] Red[' num2str(max(Y),'%0.1f') '] dBm' ' BW ' num2str(0.75*FS/(304*2^decimation),'%0.0f') ' Hz Avg ' num2str(num_sampl,'%d')]);
    title(['Peak Blue[' num2str(max(X),'%0.1f') '] Red[' num2str(max(Y),'%0.1f') '] dBm Avg ' num2str(num_sampl,'%d')]);
    [xmax,ix]=max(X);
    [ymax,iy]=max(Y);
    [zmax,iz]=max(Z);
    dmax = [xmax,ymax,zmax];
    imax = [ix,iy,iz];
    [mm,im]=max(dmax);
%   title(['Peak Red(X)[' num2str(X(imax(im)),'%0.1f') '] Green(Y)[' num2str(Y(imax(im)),'%0.1f') '] Blue(Z)[' num2str(Z(imax(im)),'%0.1f') '] dBm' ' BW ' num2str(0.75*FS/(304*2^decimation),'%0.0f') ' Hz Avg ' num2str(num_sampl,'%d')]);
    title(['Peak Red(X)[' num2str(X(imax(im)),'%0.1f') '] Green(Y)[' num2str(Y(imax(im)),'%0.1f') '] Blue(Z)[' num2str(Z(imax(im)),'%0.1f') '] dBm' ' Hz Avg ' num2str(num_sampl,'%d')]);
    p_freq=(STARTF+(STOPF-STARTF)/num_steps*imax(im))/1e6;
    %% dBm/Hz = dBm-10*log(BW)
    
    drawnow
end
