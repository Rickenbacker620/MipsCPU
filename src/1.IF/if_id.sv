import project_types::*;

module if_id(
        input logic clk,
        input reset_status_t rst,

        input logic [5:0] stall,

        input pc_t if_pc_o,
        input inst_t rom_inst_o,

        output pc_t id_pc_i,
        output inst_t id_inst_i
    );

    always_ff @ (posedge clk) begin
        if (rst == RST_ENABLE) begin
            id_pc_i <= '0;
            id_inst_i <= '0;
        end
        else if (stall[1] == 1'b1 && stall[2] == 1'b0) begin
            id_pc_i <= '0;
            id_inst_i <= '0;
        end
        else begin
            id_pc_i <= if_pc_o;
            id_inst_i <= rom_inst_o;
        end
    end

endmodule
