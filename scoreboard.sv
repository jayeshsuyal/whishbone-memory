class scoreboard();

    bit [7:0]data[256]= {`default:0};
    transaciton tr;
    mailbox #(transaciton) mbxms;
    event sconext;


    task run();
        forever begin
            mbxms.get(tr);
            if (tr.strb== 1'b0) begin
                $display("[SCO]: TRANSACTION INVALID");                
            end
            else begin
                if(tr.we == 1'b1)begin
                    data[tr.addr] = tr.wdata;
                    $display("[SCO]: DATA WRITE:- addt: %0d, data: %0d", tr.addr, tr.wdata);
                end
                else begin
                    if(tr.rdata== 8'b11) begin
                        $display("[SCO]: DEFAULT VALUE, DATA READ SUCCESSFULLY");
                    end
                    else if (tr.rdata == data[tr.data])begin
                        $display("DATA READ SUCCESSFULLY");
                    end
                end
            end
            -> sconext;
        end
    endtask
endclass