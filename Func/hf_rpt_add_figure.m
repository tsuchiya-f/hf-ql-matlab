function ret = hf_rpt_add_figure(st_ctl)

    import mlreportgen.report.*
    import mlreportgen.dom.*

    ret = 0;

    sc = Section('Title',Text(st_ctl.label));
    add(st_ctl.rpt, sc)

    fig = Figure(st_ctl.hf);    
    add(st_ctl.rpt, fig);
    
end
