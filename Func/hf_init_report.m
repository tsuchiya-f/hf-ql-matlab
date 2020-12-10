%-----------------------------------
% Initialize report
%-----------------------------------
function [st_ctl] = hf_init_report(st_ctl)

    % Determine report file name (pdf file)
    [~,name,~] = fileparts(st_ctl.file_rep);
    rpt = mlreportgen.report.Report(st_ctl.file_rep,'pdf');
    
    append(rpt, mlreportgen.report.TitlePage('Title',name))
    append(rpt, mlreportgen.report.TableOfContents)

    ch = mlreportgen.report.Chapter('Title','Test configuration');
    txt = append('DPU softare version : ', string(st_ctl.ver));
    append(ch, mlreportgen.dom.Text(txt));
    append(rpt, ch)

    % add report file 
    st_ctl.rpt = rpt;

end