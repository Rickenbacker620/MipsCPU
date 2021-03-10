import project_types::*;

module hi_lo(
    input logic clk,
    input reset_status_t rst,

    input hilo_t wb_hilo_o,

    output reg_data_t hilo_hi_o,
    output reg_data_t hilo_lo_o
);

always_ff @( posedge clk ) begin
    if (rst == RST_ENABLE) begin
        hilo_hi_o <= '0;
        hilo_lo_o <= '0;
    end
    else if (wb_hilo_o.en == REG_ENABLE) begin
        hilo_hi_o <= wb_hilo_o.hi;
        hilo_lo_o <= wb_hilo_o.lo;
    end
end

endmodule