import project_types::*;

module mem_wb(
        input logic clk,
        input reset_status_t rst,

        input reg_t mem_wreg_o,

        input reg_t wb_wreg_i

    );

    always_ff @(posedge clk) begin
        if (rst == RST_ENABLE) begin
            wb_wreg_i <= '{default:0};
        end
        else begin
            wb_wreg_i <= mem_wreg_o;
        end
    end

endmodule
