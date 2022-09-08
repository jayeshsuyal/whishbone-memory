class generator; 

    transaction tr;

    mailbox #(transaction) mbxgd;

    event sconext;
    event drvnext;
    event done; 

    int count = 0;

    function new(mailbox#(transaction) mbxgd);
        this.mbxgd = mbxgd;
        tr = new();
    endfunction

    task run();
        repeat(count) begin
            assert(tr.randomize) else $display("Randomization FAILED..!!!");
            mbxgd.put(tr);
            @(drvnext);
            @(sconext);
        end
        -> done;
    endtask
endclass