class environment();

    generator gen;
    driver drv;
    scoreboard sco;
    monitor mon; 

    event nextgd;
    event nextgs;

    mailbox #(transaction) gdmbx; /// gen and driver events
    mailbox #(transaction) msmbx; // sco and mon events
    

    function new();
        
        gen = new(gdmbx);
        drv = new(gdmbx);

        sco = new(msmbx);
        mon = new(msmbx);

        drv.drvnext = nextgd;
        gen.drvnext = nextgd;

        sco.sconext = nextgs;
        gen.sconext = nextgs;
        
    endfunction

    task pre_test();
        drv.rest();
    endtask

    task test();
        fork
            gen.run();
            drv.run();
            mon.run();
            sco.run();
        join_any    
    endtask 

    task post_test();
        wait(gen.done.triggered);
        $finish();
    endtask 

    task run();
        pre_tes();
        test();
        post_test();
    endtask

endclass

