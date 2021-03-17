import project_types::*;

module openmips_min_sopc (
    input wire clk,
    input reset_status_t rst
);

    chip_status_t ce;
    pc_t pc;
    inst_t inst;

    openmips openmips0 (
        .(*),

        .rom_ce(ce),
        .rom_addr(pc),
        .rom_data(inst)
    );

    inst_rom inst_rom0 (
        .ce(ce),
        .pc(pc),
        .inst(inst)
    );

endmodule
