import project_types::*;

module openmips(
    input logic clk,
    input reset_status_t rst,

    output chip_status_t rom_ce_o,
    output inst_addr_t rom_addr_o,
    input inst_t rom_data_i,

    output chip_status_t ram_ce_o,
    output logic ram_we_o,
    output logic[3:0] ram_sel_o,
    output ram_addr_t ram_addr_o,
    output ram_data_t ram_data_o,
    input ram_data_t ram_data_i
);

    i_regbus regbus();

    jump_t id_jumpreq;

    inst_t rom_inst_o;
    inst_t id_inst_i;

    inst_addr_t if_pc_o;
    inst_addr_t id_pc_i;

    chip_status_t if_ce_o;

    alu_t id_alu_o;
    reg_data_t id_oprd1_o;
    reg_data_t id_oprd2_o;
    reg_info_t id_wreg_o;
    alu_t ex_alu_i;
    reg_data_t ex_oprd1_i;
    reg_data_t ex_oprd2_i;
    reg_info_t ex_wreg_i;

    reg_t ex_wreg_o;
    reg_t mem_wreg_i;

    reg_t mem_wreg_o;
    reg_t wb_wreg_o;

    logic [5:0] stall;
    logic ex_stallreq;
    logic id_stallreq;
    inst_addr_t ex_link_addr_i;
    inst_addr_t id_link_addr_o;

    ram_addr_t ex_ramaddr_o;
    ram_addr_t ex_ramaddr_i;

    ram_addr_t mem_ramaddr_i;

    alu_t ex_alu_o;
    alu_t mem_alu_i;

    assign rom_ce_o = if_ce_o;
    assign rom_addr_o = if_pc_o;
    assign rom_inst_o = rom_data_i;


    regfile regfile1(.*, .read(regbus.slave));

    pc pc0(.*);

    if_id if_id0(.*);

    id id0(.*, .read(regbus.master));

    id_ex id_ex0(.*);

    ex ex0(.*);

    ex_mem ex_mem0(.*);

    mem mem0(
        .*,
        .mem_ce_o(ram_ce_o),
        .mem_we_o(ram_we_o),
        .mem_sel_o(ram_sel_o),
        .mem_addr_o(ram_addr_o),
        .mem_data_i(ram_data_i),
        .mem_data_o(ram_data_o)
    );

    mem_wb mem_wb0(.*);

    ctrl ctrl0(.*);

endmodule
