import project_types::*;

module pc(
    input logic clk,
    input reset_status_t rst,

    input logic [5:0] stall,

    input jump_t id_jumpreq,

    i_instbus.master rom,

    output inst_t if_inst_o
);

    always_ff @(posedge clk) begin
        if (rst == RST_ENABLE)
            rom.ce <= CHIP_DISABLE;
        else
            rom.ce <= CHIP_ENABLE;
    end

    always_ff @(posedge clk) begin
        if (rom.ce == CHIP_DISABLE)
            rom.addr <= '0;
        else if (stall[0] == 1'b0) begin
            if (id_jumpreq.en == JUMP_ENABLE)
                rom.addr <= id_jumpreq.addr;
            else
                rom.addr <= rom.addr + 4'h4;
        end
    end

    always_comb begin
        if (rst == RST_ENABLE) begin
            if_inst_o = '{default:0};
        end
        else begin
            if_inst_o = '{rom.addr, rom.data};
        end
    end

endmodule