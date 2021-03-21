import project_types::*;

module openmips_min_sopc (
    input wire clk,
    input reset_status_t rst
);

    chip_status_t rom_ce;
    inst_addr_t rom_pc;
    inst_t rom_inst;

    chip_status_t ram_ce;
    logic ram_we;
    logic[3:0] ram_sel;
    ram_addr_t ram_addr;
    ram_data_t ram_read_data;
    ram_data_t ram_write_data;

    openmips openmips0 (
        .*,
        .rom_ce(rom_ce),
        .rom_addr(rom_pc),
        .rom_data_i(rom_inst),

        .ram_ce_o(ram_ce),
        .ram_we_o(ram_we),
        .ram_sel_o(ram_sel),
        .ram_addr_o(ram_addr),
        .ram_data_o(ram_write_data),
        .ram_data_i(ram_read_data)
    );

    inst_rom inst_rom0 (
        .ce(rom_ce),
        .pc(rom_pc),
        .inst(rom_inst)
    );

    data_ram data_ram0(
        .*,
        .ce(ram_ce),
        .we(ram_we),
        .sel(ram_sel),
        .addr(ram_addr),
        .data_i(ram_write_data),
        .data_o(ram_read_data)
    );

endmodule
