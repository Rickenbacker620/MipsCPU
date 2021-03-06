import project_types::*;

module ex_mem (
        input logic clk,
        input reset_status_t rst,

        input reg_t ex_wreg_o,

        output reg_t mem_wreg_i
    );

    always_ff @(posedge clk) begin
        if (rst == RST_ENABLE) begin
            mem_wreg_i <= '{default : 0};
        end
        else begin
            mem_wreg_i <= ex_wreg_o;
        end
    end

endmodule
