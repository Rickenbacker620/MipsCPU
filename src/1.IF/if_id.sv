import project_types::*;

module if_id(
        input logic clk,
        input reset_status_t rst,

        input logic [5:0] stall,

        input inst_t if_inst_o,

        output inst_t id_inst_i
    );

    always_ff @ (posedge clk) begin
        if (rst == RST_ENABLE) begin
            id_inst_i <= '{default:0};
        end
        else if (stall[1] == 1'b1 && stall[2] == 1'b0) begin
            id_inst_i <= '{default:0};
        end
        else begin
            id_inst_i <= if_inst_o;
        end
    end

endmodule
