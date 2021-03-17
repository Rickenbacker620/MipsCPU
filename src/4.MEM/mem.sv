import project_types::*;

module mem(
    input reset_status_t rst,

    input reg_t mem_wreg_i,
    input ram_addr_t mem_ramaddr_i,
    input alu_t mem_alu_i,
    output reg_t mem_wreg_o,

    output chip_status_t mem_ce_o,
    output logic mem_we_o,
    output logic[3:0] mem_sel_o,
    output ram_addr_t mem_addr_o,
    output ram_data_t mem_data_o,
    input ram_data_t mem_data_i
);

    always_comb begin
        if (rst == RST_ENABLE) begin
            mem_wreg_o = '{default:0};
        end
        else begin
            mem_wreg_o = mem_wreg_i;
            mem_addr_o = mem_ramaddr_i;

            ////////////////////////////////////

            case(mem_alu_i.op)
                LW_OP: begin
                    mem_we_o = 1'b0;
                    mem_ce_o = CHIP_ENABLE;
                    mem_wreg_o.data = ram.read;
                end
                LB_OP: begin
                    mem_we_o = 1'b0;
                    mem_ce_o = CHIP_ENABLE;
                    mem_wreg_o.data = ram.read;
                end
                SW_OP: begin
                    mem_we_o = 1'b1;
                    mem_ce_o = CHIP_ENABLE;
                    mem_data_o = mem_wreg_i.data;
                end
                SB_OP: begin
                    mem_we_o = 1'b1;
                    mem_ce_o = CHIP_ENABLE;
                    mem_data_o = mem_wreg_i.data;
                end
                default: begin
                    mem_we_o = 1'b0;
                    mem_ce_o = CHIP_DISABLE;
                    mem_addr_o = '0;
                    mem_data_o = '0;
                end
            endcase
        end
    end

endmodule
