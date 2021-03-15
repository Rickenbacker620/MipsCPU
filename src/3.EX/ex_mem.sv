import project_types::*;

module ex_mem (
        input logic clk,
        input reset_status_t rst,

        input logic [5:0] stall,

        input reg_t ex_wreg_o,
        input hilo_t ex_hilo_o,


        output reg_t mem_wreg_i,
        input hilo_t mem_hilo_i

    );

    always_ff @(posedge clk) begin
        if (rst == RST_ENABLE) begin
            mem_wreg_i <= '{default:0};
            mem_hilo_i <= '{default:0};
        end
        else if(stall[3] == 1'b1 && stall[4] == 1'b0) begin
            mem_wreg_i <= '{default:0};
            mem_hilo_i <= '{default:0};
        end
        else begin
            mem_wreg_i <= ex_wreg_o;
            mem_hilo_i <= ex_hilo_o;
        end
    end

endmodule
