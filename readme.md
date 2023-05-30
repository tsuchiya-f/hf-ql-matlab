コマンドプロンプトからの実行

参考：https://www.nemotos.net/?p=1731

例）
matlab -nosplash -nodesktop -r "HF_dl_script('C:\share\Linux\doc\juice\ccsds\system_test\20210531_SCPFM_PTR_RPWI_2\20210531_SCPFM_PTR_RPWI_2_day3_xid32770.data.hf.ccsds','C:\share\Linux\doc\juice\ccsds\system_test\ql\'); exit" -logfile "C:\share\Linux\doc\juice\ccsds\system_test\ql\20210531_SCPFM_PTR_RPWI_2_day3_xid32770.data.log"

MATLABによるRPWI/HFのQL(pdf)作成手順@octave

(0) X windowが使用可能な環境でoctaveにログイン
$ ssh tsuchi@octave.gp.tohoku.ac.jp -XY

 passwd : $$****$$
	****には機器名が入る（小文字４文字）

tsuchi@octave:~$ cd Documents/MATLAB

※アカウントがtsuchiなのは、MATLABのライセンスの都合上

(1) ccsdsからHFのスペクトルを解析・描画し、pdfファイルに保存
tsuchi@octave:~/Documents/MATLAB$ ./rpwi_ccsds2pdf.sh (ccsds file name: full path)
	例) $ ./rpwi_ccsds2pdf.sh /db/JUICE/ccsds/from_esoc/RPI1_838860802_2022.279.21.09.39.514

ccsdsファイルの所在：http://octave.gp.tohoku.ac.jp/db/JUICE/ccsds/
生成されるpdfファイルの所在：http://octave.gp.tohoku.ac.jp/db/JUICE/ql/
生成されるlogファイルの所在：http://octave.gp.tohoku.ac.jp/db/JUICE/log/

(2) 複数のccsdsファイルをまとめて処理する場合
tsuchi@octave:~/Documents/MATLAB$ ./loop_rpwi_ccsds2pdf.sh (options)

(2-1) /db/JUICE/cccsds/以下のファイルを全て処理する場合（但し、未処理ファイルのみ）
tsuchi@octave:~/Documents/MATLAB$ ./loop_rpwi_ccsds2pdf.sh

(2-2) /db/JUICE/cccsds/以下のファイルを全て処理する場合（処理済みのファイルも再処理し、上書き）
tsuchi@octave:~/Documents/MATLAB$ ./loop_rpwi_ccsds2pdf.sh -f

(2-3) /db/JUICE/cccsds/from_esoc以下のファイルを処理する場合
tsuchi@octave:~/Documents/MATLAB$ ./loop_rpwi_ccsds2pdf.sh -p /db/JUICE/ccsds/from_esoc/

(2-4) /db/JUICE/cccsds/from_esoc以下の拡張子が*.ccsdsのファイルを処理する場合
tsuchi@octave:~/Documents/MATLAB$ ./loop_rpwi_ccsds2pdf.sh -p /db/JUICE/ccsds/from_esoc/ -n *.ccsds

