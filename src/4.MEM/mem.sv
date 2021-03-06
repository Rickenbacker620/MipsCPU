import project_types::*;

module mem(
        input reset_status_t rst,

        input reg_t mem_wreg_i,

        output reg_t mem_wreg_o
    );

    always_comb begin
        if (rst == RST_ENABLE) begin
            mem_wreg_o = '{default:0};
        end
        else begin
            mem_wreg_o = mem_wreg_i;
        end
    end

endmodule
