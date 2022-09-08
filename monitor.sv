class monitor();

    transaciton tr;
    mailbox #(transaction) mbxms;
    virtual wb_if vif;

    function new(mailbox #(transaciton) mbmxs);
        this.mbxms = mbxms;
    endfunction

    task run();
     tr = new();
        forever begin
               wait(vif.rst == 1'b0);
               repeat(5) @(posedge vif.clk);
               @(posedge vif.clk);
                if(vif.strb == 1'b0)begin
                    tr.strb = vif.strb;
                    repeat (2) @(posedge vif.clk);
                    $$display("[MON]: STRB IS ZERO");
                    mbxms.put(tr); 
                end
                else begin
                    @(posedge vif.clk)
                    tr.we = vif.we;
                    tr.strb = vif.strb;
                    tr.addr = vif.addr;
                    tr.wdata = vif.addr;
                    tr.rdata = vif.rdata;
                   (posedge vif.clk); 
                    $$display("[MON: STRB is HIGH(VALID)");
                    mbxms.put(tr);
                end

            end
    endtask 
endclass