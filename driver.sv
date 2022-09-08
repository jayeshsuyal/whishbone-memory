class driver

    virtual wb_if vif;
    transaciton tr;
    mailbox #(transaciton)mbxgd;
    event drvnext;


    function new(mailbox #(transaciton) mbxgd)
        this.mbxgd = mbxgd;        
    endfunction

    task reset();

        vif.rst <= 1'b1;
        vif.we <= 0;
        vif.strb <= 0;
        vif.addr <= 0;
        vif.wdata <= 0;
        repeat(10) vif.clk;
        vif.rst <= 1'b0;
        repeat(5) vif.clk;
        $$display("[DRV]: RESET DONE");
    endtask 

    task write();

        @(posedge vif.clk);
        $display("[DRV]: WRITE MODE");
        vif.rst <= 1'b0;
        vif.we<= 1'b1;
        vif.strb <= 1'b1;
        vif.addr <= tr.addr;
        vif.wdata <= tr.wdata;
        @(posedge vif.clk);
        @(posedge vif.ack);
        -> drvnext;
    endtask

    task read();
        @(posedge vif.clk);
        $display("[DRV]: READ MODE");
        vif.rst <= 1'b0;
        vif.we <= 1'b0;
        vif.strb <= 1'b1;
        vif.addr <= tr.addr;
        @(posedge vif.clk);
        @(posedge vif.ack);
        -> drvnext;
    endtask

    task random();
        @(posedge vif.clk);
        $display("[DRV]: RANDOM MODE");
        vif.rst <= 1'b0;
        vif.we <= tr.strb;
        vif.strb <= tr.strb;
        vif.addr <= tr.addr; 

        if(vif.we <= 1'b1) begin
        vif.wdata <= tr.wdata;
        end
        repeat(2) @(posedge vif.clk);
        -> drvnext;
    endtask

    task run();
        forever begin
            mbxgd.get(tr);
            if (tr.opcode==0) begin
                write();
            end
            else if (tr.opcode == 1) begin
                read();
            end
            else if(tr.opcode ==2) begin
                random();
            end
    end
    endtask 
endclass