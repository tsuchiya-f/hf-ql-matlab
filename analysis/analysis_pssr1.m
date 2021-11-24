dir_in  = "C:\share\Linux\juice_test\20211114_pssr1_SGin\";
file_in = "HF_20211114-1512.mat";
%file_in = "HF_20211114-1828.mat";
label   = "HF PSSR1";

n_skip = 100;

%trange=[0 35];
I_limit = 1e9;
label_lim = sprintf(" (I > %7.1e)", I_limit);

load(join([dir_in, file_in],""), "time", "freq", "st_data_spec");
x = [min(time) max(time)];
y = [min(freq) max(freq)];
if ~exist('trange', 'var'); trange = x; end

[I_xy, Q_xy, U_xy, V_xy] = hf_proc_get_stokes(transpose(st_data_spec.xx), transpose(st_data_spec.yy), transpose(st_data_spec.re_xy), transpose(st_data_spec.im_xy));
% idx = find(I_xy < I_limit);
% Q_xy(idx)=NaN; U_xy(idx)=NaN; V_xy(idx)=NaN;
[dop_xy, dol_xy, doc_xy, ang_xy] = hf_proc_get_pol(I_xy, Q_xy, U_xy, V_xy);
idx = find(ang_xy > 90.0); ang_xy(idx) = ang_xy(idx) - 180.0;

% [I_yz, Q_yz, U_yz, V_yz] = hf_proc_get_stokes(transpose(st_data_spec.yy), transpose(st_data_spec.zz), transpose(st_data_spec.re_yz), transpose(st_data_spec.im_yz));
% idx = find(I_yz < I_limit);
% Q_yz(idx)=NaN; U_yz(idx)=NaN; V_yz(idx)=NaN;
% [dop_yz, dol_yz, doc_yz, ang_yz] = hf_proc_get_pol(I_yz, Q_yz, U_yz, V_yz);
% idx = find(ang_yz > 90.0); ang_yz(idx) = ang_yz(idx) - 180.0;
% 
% [I_zx, Q_zx, U_zx, V_zx] = hf_proc_get_stokes(transpose(st_data_spec.zz), transpose(st_data_spec.xx), transpose(st_data_spec.re_zx), transpose(st_data_spec.im_zx));
% idx = find(I_zx < I_limit);
% Q_zx(idx)=NaN; U_zx(idx)=NaN; V_zx(idx)=NaN;
% [dop_zx, dol_zx, doc_zx, ang_zx] = hf_proc_get_pol(I_zx, Q_zx, U_zx, V_zx);
% idx = find(ang_zx > 90.0); ang_zx(idx) = ang_zx(idx) - 180.0;

nt = numel(time);
nf = numel(freq);
mask = ones(nf,nt);
pow = I_xy;
idx = find(pow < I_limit);
mask(idx) = 0.0;

I_xy_p = zeros(1,nt);
dol_xy_p = zeros(1,nt);
doc_xy_p = zeros(1,nt);
ang_xy_p = zeros(1,nt);

U_xy_p = zeros(1,nt);
Q_xy_p = zeros(1,nt);
V_xy_p = zeros(1,nt);

for i=1:nt
    [value,idx] = max(I_xy(:,i));
    I_xy_p(i) = I_xy(idx,i);
    dol_xy_p(i) = dol_xy(idx,i);
    doc_xy_p(i) = doc_xy(idx,i);
    ang_xy_p(i) = ang_xy(idx,i);
    U_xy_p(i) = U_xy(idx,i);
    Q_xy_p(i) = Q_xy(idx,i);
    V_xy_p(i) = V_xy(idx,i);
end

x_sp = transpose(st_data_spec.xx);
x_sp = red_mean(x_sp, mask, n_skip);
y_sp = transpose(st_data_spec.yy);
y_sp = red_mean(y_sp, mask, n_skip);

I_xy = red_mean(I_xy, mask, n_skip);
dol_xy = red_mean(dol_xy, mask, n_skip);
doc_xy = red_mean(doc_xy, mask, n_skip);
ang_xy = red_mean(ang_xy, mask, n_skip);

tiledlayout(3,4)

% polarization
nexttile
plot(time, I_xy_p,'o');
xlim(trange);
title('I xy @ peak intensity');
xlabel ('Time [s]');
ylabel ('Intensity (I xy)');

nexttile
plot(time, dol_xy_p,'o');
xlim(trange);
ylim([-0.1,1.1]);
title('DoL xy @ peak intensity');
xlabel ('Time [s]');
ylabel ('Degree of linear pol');

nexttile
plot(time, doc_xy_p,'o');
xlim(trange);
ylim([-1.1,1.1]);
title('DoC xy @ peak intensity');
xlabel ('Time [s]');
ylabel ('Degree of circular pol');

nexttile
plot(time, ang_xy_p,'o');
xlim(trange);
ylim([-90,90]);
title('Pol angle xy @ peak intensity');
xlabel ('Time [s]');
ylabel ('Polarization angle');
    
% % Stokes parameter
% nexttile
% plot(time, I_xy_p,'o');
% xlim(trange);
% title('I xy @ peak intensity');
% xlabel ('Time [s]');
% ylabel ('Intensity (I xy)');
% 
% nexttile
% plot(time, U_xy_p,'o');
% xlim(trange);
% title('U xy @ peak intensity');
% xlabel ('Time [s]');
% ylabel ('Stoles U');
% 
% nexttile
% plot(time, Q_xy_p,'o');
% xlim(trange);
% title('Q xy @ peak intensity');
% xlabel ('Time [s]');
% ylabel ('Stokes Q');
% 
% nexttile
% plot(time, V_xy_p,'o');
% xlim(trange);
% title('V xy @ peak intensity');
% xlabel ('Time [s]');
% ylabel ('Stokes V');

% --- XY stokes ---
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

% --- X & Y powers ---
nexttile
imagesc(x, y, x_sp);
colorbar
title([label,'X-channel power']);
xlabel ('Time [s]');
ylabel ('Frequency [kHz]');
xlim(trange);

nexttile
imagesc(x, y, y_sp);
colorbar
title('Y-channel power');
xlabel ('Time [s]');
ylabel ('Frequency [kHz]');
xlim(trange);
