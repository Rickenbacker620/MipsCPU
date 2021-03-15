import project_types::*;

module mem_wb(
        input logic clk,
        input reset_status_t rst,

        input logic [5:0] stall,

        input reg_t mem_wreg_o,
        input hilo_t mem_hilo_o,

        input reg_t wb_wreg_o,
        input hilo_t wb_hilo_o

    );

    always_ff @(posedge clk) begin
        if (rst == RST_ENABLE) begin
            wb_wreg_o <= '{default:0};
            wb_hilo_o <= '{default:0};
        end
        else if(stall[4] == 1'b1 && stall[5] == 1'b0) begin
            wb_wreg_o <= '{default:0};
            wb_hilo_o <= '{default:0};
        end
        else begin
            wb_wreg_o <= mem_wreg_o;
            wb_hilo_o <= mem_hilo_o;
        end
    end

endmodule
