class transaciton; 

    rand bit we;
    rand bit strb;
    bit ack;
    rand bit [7:0] addr;
    rand bit [7:0] wdata;
    rand bit [7:0] rdata;
    rand bit [1:0] opmode;  // 0 = write, 1 = read, 2 = random 

    constraint opmode_c {opcode => 0; opcode < 3}
    constraint addr_c {addr == 5} 
    constraint data_c {wdata > 0 ; wdata<= 8}

    function transaction copy();
        copy = new();
        copy.we = this.we;
        copy.strb = this.strb;
        copy.ack = this.ack;
        copy.addr = this.addr;
        copy.wdata = this.wdata;
        copy.rdata = this.rdata;
        copy.opmode = this.opmode;
    endfunction

    function void display(input string tag);
        $display("[%s]- Mode:%0d, WE: %0b, Strobe: %0d, addr: %0d, Write_data:%0d, Read_Data: %0d", tag, opmode, we, strb, addr, wdata, rdata); 
    endfunction

endclass