import project_types::*;
import decode_table::*;

module id_ex (
        input logic clk,
        input reset_status_t rst,

        input alu_t id_alu_o,
        input reg_data_t id_oprd1_o,
        input reg_data_t id_oprd2_o,
        input reg_info_t id_wreg_o,

        output alu_t ex_alu_i,
        output reg_data_t ex_oprd1_i,
        output reg_data_t ex_oprd2_i,
        output reg_info_t ex_wreg_i
    );

    always_ff @(posedge clk) begin
        if (rst == RST_ENABLE) begin
            ex_alu_i <= '{default:0};
            ex_oprd1_i <= '0;
            ex_oprd2_i <= '0;
            ex_wreg_i <= '{default:0};
        end
        else begin
            ex_alu_i <= id_alu_o;
            ex_oprd1_i <= id_oprd1_o;
            ex_oprd2_i <= id_oprd2_o;
            ex_wreg_i <= id_wreg_o;
        end
    end

endmodule
