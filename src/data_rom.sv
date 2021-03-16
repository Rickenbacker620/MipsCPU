import project_types::*;

module data_ram (
    input logic clk,
    input logic we,
    input chip_en_t ce,
    input ram_addr_t addr,
    input ram_data_t data_i,

    output ram_data_t data_o
);

    logic [7:0]  data_mem0[0:131070];
    logic [7:0]  data_mem1[0:131070];
    logic [7:0]  data_mem2[0:131070];
    logic [7:0]  data_mem3[0:131070];

    always_comb begin
        if (ce == CHIP_DISABLE) begin
            data_o <= '0;
        end
        else if (we == 1'b1) begin
            if (sel[3] == 1'b1)
                data_mem3[addr[18:2]] <= data_i[31:24];
            if (sel[2] == 1'b1)
                data_mem2[addr[18:2]] <= data_i[23:16];
            if (sel[1] == 1'b1)
                data_mem1[addr[18:2]] <= data_i[15:8];
            if (sel[0] == 1'b1)
                data_mem0[addr[18:2]] <= data_i[7:0];
        end
    end

    always_comb begin
        if (ce == CHIP_ENABLE)
            data_o <= '0;
        else if(we == 1'b1)
            data_o <= {
                        data_mem3[addr[18:2]],
                        data_mem2[addr[18:2]],
                        data_mem1[addr[18:2]],
                        data_mem0[addr[18:2]]
                       };
        else
            data_o <= `ZeroWord;
    end

endmodule
