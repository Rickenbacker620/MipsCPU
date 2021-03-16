import project_types::*;

module mem(
        input reset_status_t rst,

        input reg_t mem_wreg_i,
        input hilo_t mem_hilo_i,
        input ram_addr_t mem_ramaddr_i,
        input alu_t mem_alu_i,

        output reg_t mem_wreg_o,
        output hilo_t mem_hilo_o
    );

    always_comb begin
        if (rst == RST_ENABLE) begin
            mem_wreg_o = '{default:0};
            mem_hilo_o = '{default:0};
        end
        else begin
            mem_wreg_o = mem_wreg_i;
            mem_hilo_o = mem_hilo_i;

            ////////////////////////////////////

            if (mem_alu_i.op == LW_OP) begin
                mem_wreg_o =
            end


        end
    end

endmodule
