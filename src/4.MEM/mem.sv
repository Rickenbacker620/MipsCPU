import project_types::*;

module mem(
        input reset_status_t rst,

        input reg_t mem_wreg_i,
        input ram_addr_t mem_ramaddr_i,
        input alu_t mem_alu_i,

        output reg_t mem_wreg_o,

        i_membus.master ram

    );

    always_comb begin
        if (rst == RST_ENABLE) begin
            mem_wreg_o = '{default:0};
        end
        else begin
            mem_wreg_o = mem_wreg_i;
            ram.addr = mem_ramaddr_i;

            ////////////////////////////////////

            case(mem_alu_i.op)
                LW_OP: begin
                    ram.we = 1'b0;
                    ram.ce = CHIP_ENABLE;
                    mem_wreg_o.data = ram.read;
                end
                LB_OP: begin
                    ram.we = 1'b0;
                    ram.ce = CHIP_ENABLE;
                    mem_wreg_o.data = ram.read;
                end
                SW_OP: begin
                    ram.we = 1'b1;
                    ram.ce = CHIP_ENABLE;
                    ram.write = mem_wreg_i.data;
                end
                SB_OP: begin
                    ram.we = 1'b1;
                    ram.ce = CHIP_ENABLE;
                    ram.write = mem_wreg_i.data;
                end
                default: begin
                    ram.we = 1'b0;
                    ram.ce = CHIP_DISABLE;
                    ram.addr = '0;
                    ram.write = '0;
                end
            endcase
        end
    end

endmodule
