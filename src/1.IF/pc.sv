import project_types::*;

module pc(
    input logic clk,
    input reset_status_t rst,

    input logic [5:0] stall,
    input jump_t id_jumpreq,

    output pc_t if_pc_o,
    output chip_status_t if_ce_o
);

    always_ff @(posedge clk) begin
        if (rst == RST_ENABLE)
            if_ce_o <= CHIP_DISABLE;
        else
            if_ce_o <= CHIP_ENABLE;
    end

    always_ff @(posedge clk) begin
        if (if_ce_o == CHIP_DISABLE)
            if_pc_o <= '0;
        else if (stall[0] == 1'b0) begin
            if (id_jumpreq.en == JUMP_ENABLE)
                if_pc_o <= id_jumpreq.addr;
            else
                if_pc_o <= if_pc_o + 4'h4;
        end
    end

endmodule