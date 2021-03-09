import project_types::*;
module hi_lo(
    input logic clk,
    input reset_status_t clk,

    input reg_en_t hilo_write_en,
    input reg_data_t hi_data_i,
    input reg_data_t lo_data_i,

    output reg_data_t hi_data_o,
    output reg_data_t lo_data_o
);

always_ff @( posedge clk ) begin
    if (rst == RST_ENABLE) begin
        hi_o <= '0;
        lo_o <= '0;
    end
    else if (we == REG_ENABLE) begin
        hi_o <= hi_i;
        lo_o <= lo_i;
    end
end