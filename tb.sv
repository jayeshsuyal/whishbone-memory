module tb();

    virtual wb_if vif;
    mem_wb dut (vif.clk, vif.we, vif.strb, vif.rst, vif.addr, vif.wdata, vif.rdata, vif.ack);

    initial begin
        vif.clk <= 0;
    end
     
    always #5 vif.clk = ~vif.clk;

    environment env;

    initial begin
         env = new(vif);
         env.gen.count(20);
         env.run();
    end
    
    initial begin
        $dumpfile("dump.vcd");
        $dumpvars;
    end
endmodule