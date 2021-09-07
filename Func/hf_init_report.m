%-----------------------------------
% Initialize report
%-----------------------------------
function [st_ctl] = hf_init_report(st_ctl)

    % Determine report file name (pdf file)
    [~,name,~] = fileparts(st_ctl.file_rep);
    rpt = mlreportgen.report.Report(st_ctl.file_rep,'pdf');
    
    append(rpt, mlreportgen.report.TitlePage('Title',name))
    append(rpt, mlreportgen.report.TableOfContents)

    ch = mlreportgen.report.Chapter('Test information');
    txt = append('Test title : ', st_ctl.title);
    append(ch, mlreportgen.dom.Text(txt));
    txt = append('Location of CCSDS file  : ', st_ctl.dir_out);
    append(ch, mlreportgen.dom.Text(txt));
    append(rpt, ch)

    % add report file 
    st_ctl.rpt = rpt;

end