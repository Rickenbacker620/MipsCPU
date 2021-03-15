import project_types::*;

module pc(
    input logic clk,
    input reset_status_t rst,

    input logic [5:0] stall,

    input jump_t id_jump_o,

    i_fetch_inst.master fetch,

    output inst_t if_inst_o
);

    always_ff @(posedge clk) begin
        if (rst == RST_ENABLE)
            fetch.en <= CHIP_DISABLE;
        else
            fetch.en <= CHIP_ENABLE;
    end

    always_ff @(posedge clk) begin
        if (fetch.en == CHIP_DISABLE)
            fetch.addr <= '0;
        else if (stall[0] == 1'b0) begin
            if (id_jump_o.en == JUMP_ENABLE)
                fetch.addr <= id_jump_o.addr;
            else
                fetch.addr <= fetch.addr + 4'h4;
        end
    end

    always_comb begin
        if (rst == RST_ENABLE) begin
            if_inst_o = '{default:0};
        end
        else begin
            if_inst_o = '{fetch.addr, fetch.data};
        end
    end

endmodule