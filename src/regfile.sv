import project_types::*;

module regfile(
        input logic clk,
        input reset_status_t rst,

        input reg_t wb_wreg_o,

        i_fetch_rreg.slave read
    );

    reg_data_t regs[0: 31];

    always_ff @( posedge clk ) begin
        if (rst == RST_DISABLE) begin
            if ((wb_wreg_o.en) && (wb_wreg_o.addr!= 5'h0)) begin
                regs[wb_wreg_o.addr] <= wb_wreg_o.data;
            end
        end
    end

    function void fetch_reg(
        input reg_info_t info,
        output reg_data_t data
    );
        if (rst == RST_ENABLE) begin
            data = '0;
        end
        else if (info.addr == 5'h0) begin
            data = '0;
        end
        else if ((info.en == REG_ENABLE) && (wb_wreg_o.en == REG_ENABLE) && (info.addr == wb_wreg_o.addr)) begin
            data = wb_wreg_o.data;
        end
        else if (info.en == REG_ENABLE) begin
            data = regs[info.addr];
        end
        else begin
            data = '0;
        end
    endfunction

    always_comb begin
        fetch_reg(read.r1_info, read.r1_data);
        fetch_reg(read.r2_info, read.r2_data);
    end

endmodule
