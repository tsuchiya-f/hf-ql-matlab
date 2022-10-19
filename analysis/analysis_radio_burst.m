clear all;

% dir_in  = "C:\share\Linux\juice_test\20211104_radio_burst_SGin\";
% file_in = "HF_20211104-0835.mat";
% label   = "HF radio-burst tested on 2021-11-04 08:35";

%dir_in  = "C:\share\Linux\juice_test\20211102_radio_burst_SGin\";
%file_in = "HF_20211102-1540.mat";
%label   = "HF radio-burst tested on 2021-11-02 15:40";

%dir_in  = "C:\share\Linux\juice_test\20211110_radio_burst_SGin\";
%%file_in = "HF_20211110-0922.mat";
%%label   = "HF radio-burst/phase: X=0.0, Y=90.0";
%file_in = "HF_20211110-1633.mat";
%label   = "HF radio-burst";

% dir_in  = "C:\share\Linux\juice_test\20211110_pssr1_SGin\";
% %file_in = "HF_20211110-1756.mat";
% file_in = "HF_20211111-0120.mat";
% label   = "HF PSSR1";

%dir_in  = "C:\share\Linux\juice_test\20211116_radio-burst_SGin\";
%%file_in = "HF_20211116-0622.mat";
%file_in = "HF_20211116-1241.mat";
%label   = "HF Radio-burst";

dir_in  = "C:\share\Linux\juice_test\20211126_radio_burst_SGin\";
file_in = "HF_20211126-1252.mat";
label   = "HF Radio-burst";

%trange=[205 290];
I_limit = 1e7;
label_lim = sprintf(" (I > %7.1e)", I_limit);

load(join([dir_in, file_in],""), "time", "freq", "st_data_spec");
x = [min(time) max(time)];
y = [min(freq) max(freq)];
if ~exist('trange', 'var'); trange = x; end
nt = numel(time);
nf = numel(freq);

[I_xy, Q_xy, U_xy, V_xy] = hf_proc_get_stokes(transpose(st_data_spec.xx), transpose(st_data_spec.yy), transpose(st_data_spec.re_xy), transpose(st_data_spec.im_xy));
idx = find(I_xy < I_limit);
Q_xy(idx)=NaN; U_xy(idx)=NaN; V_xy(idx)=NaN;
[dop_xy, dol_xy, doc_xy, ang_xy] = hf_proc_get_pol(I_xy, Q_xy, U_xy, V_xy);
idx = find(ang_xy > 90.0); ang_xy(idx) = ang_xy(idx) - 180.0;

[I_yz, Q_yz, U_yz, V_yz] = hf_proc_get_stokes(transpose(st_data_spec.yy), transpose(st_data_spec.zz), transpose(st_data_spec.re_yz), transpose(st_data_spec.im_yz));
idx = find(I_yz < I_limit);
Q_yz(idx)=NaN; U_yz(idx)=NaN; V_yz(idx)=NaN;
[dop_yz, dol_yz, doc_yz, ang_yz] = hf_proc_get_pol(I_yz, Q_yz, U_yz, V_yz);
idx = find(ang_yz > 90.0); ang_yz(idx) = ang_yz(idx) - 180.0;

[I_zx, Q_zx, U_zx, V_zx] = hf_proc_get_stokes(transpose(st_data_spec.zz), transpose(st_data_spec.xx), transpose(st_data_spec.re_zx), transpose(st_data_spec.im_zx));
idx = find(I_zx < I_limit);
Q_zx(idx)=NaN; U_zx(idx)=NaN; V_zx(idx)=NaN;
[dop_zx, dol_zx, doc_zx, ang_zx] = hf_proc_get_pol(I_zx, Q_zx, U_zx, V_zx);
idx = find(ang_zx > 90.0); ang_zx(idx) = ang_zx(idx) - 180.0;

% get value @ peak intensity
I_xy_p = zeros(1,nt);
dol_xy_p = zeros(1,nt);
doc_xy_p = zeros(1,nt);
ang_xy_p = zeros(1,nt);
for i=1:nt
    [value,idx] = max(I_xy(:,i));
    I_xy_p(i) = I_xy(idx,i);
    dol_xy_p(i) = dol_xy(idx,i);
    doc_xy_p(i) = doc_xy(idx,i);
    ang_xy_p(i) = ang_xy(idx,i);
end

I_yz_p = zeros(1,nt);
dol_yz_p = zeros(1,nt);
doc_yz_p = zeros(1,nt);
ang_yz_p = zeros(1,nt);
for i=1:nt
    [value,idx] = max(I_yz(:,i));
    I_yz_p(i) = I_yz(idx,i);
    dol_yz_p(i) = dol_yz(idx,i);
    doc_yz_p(i) = doc_yz(idx,i);
    ang_yz_p(i) = ang_yz(idx,i);
end

I_zx_p = zeros(1,nt);
dol_zx_p = zeros(1,nt);
doc_zx_p = zeros(1,nt);
ang_zx_p = zeros(1,nt);
for i=1:nt
    [value,idx] = max(I_zx(:,i));
    I_zx_p(i) = I_zx(idx,i);
    dol_zx_p(i) = dol_zx(idx,i);
    doc_zx_p(i) = doc_zx(idx,i);
    ang_zx_p(i) = ang_zx(idx,i);
end

% === summary plots ===
figure(1)
tiledlayout(3,5)

% --- X ---
nexttile
imagesc(x, y, transpose(st_data_spec.x));
colorbar
title([label,'X-channel power']);
xlabel ('Time [s]');
ylabel ('Frequency [kHz]');
xlim(trange);

nexttile
imagesc(x, y, I_xy);
colorbar
title('I xy');
xlabel ('Time [s]');
ylabel ('Frequency [kHz]');
xlim(trange);

nexttile
imagesc(x, y, dol_xy, [0,1]);
colorbar
title(['Degree of linear pol xy',label_lim]);
xlabel ('Time [s]');
ylabel ('Frequency [kHz]');
xlim(trange);

nexttile
imagesc(x, y, doc_xy, [-1,1]);
colorbar
title(['Degree of circular pol xy',label_lim]);
xlabel ('Time [s]');
ylabel ('Frequency [kHz]');
xlim(trange);

nexttile
imagesc(x, y, ang_xy, [-90,90]);
colorbar
title(['Pol angle xy',label_lim]);
xlabel ('Time [s]');
ylabel ('Frequency [kHz]');
xlim(trange);

% --- Y ---
nexttile
imagesc(x, y, transpose(st_data_spec.y));
colorbar
title('Y-channel power');
xlabel ('Time [s]');
ylabel ('Frequency [kHz]');
xlim(trange);

nexttile
imagesc(x, y, I_yz);
colorbar
title('I yz');
xlabel ('Time [s]');
ylabel ('Frequency [kHz]');
xlim(trange);

nexttile
imagesc(x, y, dol_yz, [0,1]);
colorbar
title(['Degree of linear pol yz',label_lim]);
xlabel ('Time [s]');
ylabel ('Frequency [kHz]');
xlim(trange);

nexttile
imagesc(x, y, doc_yz, [-1,1]);
colorbar
title(['Degree of circular pol yz',label_lim]);
xlabel ('Time [s]');
ylabel ('Frequency [kHz]');
xlim(trange);

nexttile
imagesc(x, y, ang_yz, [-90,90]);
colorbar
title(['Pol angle yz',label_lim]);
xlabel ('Time [s]');
ylabel ('Frequency [kHz]');
xlim(trange);

% --- Z ---
nexttile
imagesc(x, y, transpose(st_data_spec.z));
colorbar
title('Z-channel power');
xlabel ('Time [s]');
ylabel ('Frequency [kHz]');
xlim(trange);

nexttile
imagesc(x, y, I_zx);
colorbar
title('I zx');
xlabel ('Time [s]');
ylabel ('Frequency [kHz]');
xlim(trange);

nexttile
imagesc(x, y, dol_zx, [0,1]);
colorbar
title(['Degree of linear pol zx',label_lim]);
xlabel ('Time [s]');
ylabel ('Frequency [kHz]');
xlim(trange);

nexttile
imagesc(x, y, doc_zx, [-1,1]);
colorbar
title(['Degree of circular pol zx',label_lim]);
xlabel ('Time [s]');
ylabel ('Frequency [kHz]');
xlim(trange);

nexttile
imagesc(x, y, ang_zx, [-90,90]);
colorbar
title(['Pol angle zx',label_lim]);
xlabel ('Time [s]');
ylabel ('Frequency [kHz]');
xlim(trange);

% === XY ===
figure(2)
tiledlayout(2,4)

nexttile
imagesc(x, y, I_xy);
colorbar
title('I xy');
xlabel ('Time [s]');
ylabel ('Frequency [kHz]');
xlim(trange);

nexttile
imagesc(x, y, dol_xy, [0,1]);
colorbar
title(['Degree of linear pol xy',label_lim]);
xlabel ('Time [s]');
ylabel ('Frequency [kHz]');
xlim(trange);

nexttile
imagesc(x, y, doc_xy, [-1,1]);
colorbar
title(['Degree of circular pol xy',label_lim]);
xlabel ('Time [s]');
ylabel ('Frequency [kHz]');
xlim(trange);

nexttile
imagesc(x, y, ang_xy, [-90,90]);
colorbar
title(['Pol angle xy',label_lim]);
xlabel ('Time [s]');
ylabel ('Frequency [kHz]');
xlim(trange);

nexttile
plot(time, I_xy_p, 'o');
title('I xy @ peak');
xlabel ('Time [s]');
ylabel ('Slokes I xy');
xlim(trange);

nexttile
plot(time, dol_xy_p, 'o');
title('Degree of linear pol xy @ peak I');
xlabel ('Time [s]');
ylabel ('Degree of linear pol');
xlim(trange);
ylim([-0.1,1.1]);

nexttile
plot(time, doc_xy_p, 'o');
title('Degree of circular pol xy @ peak I');
xlabel ('Time [s]');
ylabel ('Degree of circular pol');
xlim(trange);
ylim([-1.1,1.1]);

nexttile
plot(time, ang_xy_p, 'o');
title('Pol angle xy @ peak I');
xlabel ('Time [s]');
ylabel ('Pol angle [deg]');
xlim(trange);
ylim([-95,95]);

% === YZ ===
figure(3)
tiledlayout(2,4)

nexttile
imagesc(x, y, I_yz);
colorbar
title('I yz');
xlabel ('Time [s]');
ylabel ('Frequency [kHz]');
xlim(trange);

nexttile
imagesc(x, y, dol_yz, [0,1]);
colorbar
title(['Degree of linear pol yz',label_lim]);
xlabel ('Time [s]');
ylabel ('Frequency [kHz]');
xlim(trange);

nexttile
imagesc(x, y, doc_yz, [-1,1]);
colorbar
title(['Degree of circular pol yz',label_lim]);
xlabel ('Time [s]');
ylabel ('Frequency [kHz]');
xlim(trange);

nexttile
imagesc(x, y, ang_yz, [-90,90]);
colorbar
title(['Pol angle yz',label_lim]);
xlabel ('Time [s]');
ylabel ('Frequency [kHz]');
xlim(trange);

nexttile
plot(time, I_yz_p, 'o');
title('I yz @ peak');
xlabel ('Time [s]');
ylabel ('Slokes I');
xlim(trange);

nexttile
plot(time, dol_yz_p, 'o');
title('Degree of linear pol yz @ peak I');
xlabel ('Time [s]');
ylabel ('Degree of linear pol');
xlim(trange);
ylim([-0.1,1.1]);

nexttile
plot(time, doc_yz_p, 'o');
title('Degree of circular pol yz @ peak I');
xlabel ('Time [s]');
ylabel ('Degree of circular pol');
xlim(trange);
ylim([-1.1,1.1]);

nexttile
plot(time, ang_yz_p, 'o');
title('Pol angle yz @ peak I');
xlabel ('Time [s]');
ylabel ('Pol angle [deg]');
xlim(trange);
ylim([-95,95]);

% === ZX ===
figure(4)
tiledlayout(2,4)

nexttile
imagesc(x, y, I_zx);
colorbar
title('I zx');
xlabel ('Time [s]');
ylabel ('Frequency [kHz]');
xlim(trange);

nexttile
imagesc(x, y, dol_zx, [0,1]);
colorbar
title(['Degree of linear pol zx',label_lim]);
xlabel ('Time [s]');
ylabel ('Frequency [kHz]');
xlim(trange);

nexttile
imagesc(x, y, doc_zx, [-1,1]);
colorbar
title(['Degree of circular pol zx',label_lim]);
xlabel ('Time [s]');
ylabel ('Frequency [kHz]');
xlim(trange);

nexttile
imagesc(x, y, ang_zx, [-90,90]);
colorbar
title(['Pol angle zx',label_lim]);
xlabel ('Time [s]');
ylabel ('Frequency [kHz]');
xlim(trange);

nexttile
plot(time, I_xy_p, 'o');
title('I zx @ peak');
xlabel ('Time [s]');
ylabel ('Slokes I');
xlim(trange);

nexttile
plot(time, dol_zx_p, 'o');
title('Degree of linear pol zx @ peak I');
xlabel ('Time [s]');
ylabel ('Degree of linear pol');
xlim(trange);
ylim([-0.1,1.1]);

nexttile
plot(time, doc_zx_p, 'o');
title('Degree of circular pol zx @ peak I');
xlabel ('Time [s]');
ylabel ('Degree of circular pol');
xlim(trange);
ylim([-1.1,1.1]);

nexttile
plot(time, ang_zx_p, 'o');
title('Pol angle zx @ peak I');
xlabel ('Time [s]');
ylabel ('Pol angle [deg]');
xlim(trange);
ylim([-95,95]);

