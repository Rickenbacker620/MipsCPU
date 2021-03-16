import project_types::*;

module data_ram (
    input logic clk,

    i_membus.slave ram
);

    logic [7:0]  data_mem0[0:131070];
    logic [7:0]  data_mem1[0:131070];
    logic [7:0]  data_mem2[0:131070];
    logic [7:0]  data_mem3[0:131070];

    always_comb begin
        if (ram.ce == CHIP_DISABLE) begin
            ram.read <= '0;
        end
        else if (ram.we == 1'b1) begin
            // if (sel[3] == 1'b1)
            //     data_mem3[ram.addr[18:2]] <= ram.write[31:24];
            // if (sel[2] == 1'b1)
            //     data_mem2[ram.addr[18:2]] <= ram.write[23:16];
            // if (sel[1] == 1'b1)
            //     data_mem1[ram.addr[18:2]] <= ram.write[15:8];
            // if (sel[0] == 1'b1)
            //     data_mem0[ram.addr[18:2]] <= ram.write[7:0];
            data_mem3[ram.addr[18:2]] <= ram.write[31:24];
            data_mem2[ram.addr[18:2]] <= ram.write[23:16];
            data_mem1[ram.addr[18:2]] <= ram.write[15:8];
            data_mem0[ram.addr[18:2]] <= ram.write[7:0];
        end
    end

    always_comb begin
        if (ram.ce == CHIP_ENABLE)
            ram.read <= '0;
        else if(ram.we == 1'b1)
            ram.read <= {
                        data_mem3[ram.addr[18:2]],
                        data_mem2[ram.addr[18:2]],
                        data_mem1[ram.addr[18:2]],
                        data_mem0[ram.addr[18:2]]
                       };
        else
            ram.read <= '0;
    end

endmodule
