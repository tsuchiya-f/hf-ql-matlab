dir_in  = "C:\share\Linux\juice_test\20211114_pssr1_SGin\";
file_in = "HF_20211114-1118.mat";
label   = "HF PSSR1";

fmag = 10;

%trange=[0 35];
I_limit = 1e9;
label_lim = sprintf(" (I > %7.1e)", I_limit);

load(join([dir_in, file_in],""), "time", "freq", "st_data_spec");
x = [min(time) max(time)];
y = [min(freq) max(freq)];
if ~exist('trange', 'var'); trange = x; end

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

nt = numel(time);
nf = numel(freq);
mask = ones(nf,nt);
pow = I_xy;
idx = find(pow < I_limit);
mask(idx) = 0.0;

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
