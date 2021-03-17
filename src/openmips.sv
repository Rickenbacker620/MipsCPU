import project_types::*;

module openmips(
    input logic clk,
    input reset_status_t rst,

    input inst_t rom_data

    output chip_status_t rom_ce,
    output pc_t rom_addr,
);

    i_regbus regbus();

    i_membus membus();

    jump_t id_jumpreq;

    inst_t rom_inst_o;
    inst_t id_inst_i;

    pc_t if_pc_o;

    pc_t id_pc_i;


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
    logic id_in_delayslot_i;
    logic ex_now_in_delayslot_i;
    logic ex_stallreq;
    logic id_stallreq;
    pc_t ex_link_addr_i;
    logic id_next_in_delayslot_o;

    logic id_now_in_delayslot_o;
    pc_t id_link_addr_o;

    ram_addr_t ex_ramaddr_o;
    ram_addr_t ex_ramaddr_i;

    ram_addr_t mem_ramaddr_i;

    alu_t ex_alu_o;
    alu_t mem_alu_i;

    assign rom_ce = if_ce_o;
    assign rom_addr = if_pc_o;

    assign rom_inst_o = rom_data;

    regfile regfile1(.*, .read(regbus.slave));

    pc pc0(.*);

    if_id if_id0(.*);

    id id0(.*, .read(regbus.master));

    id_ex id_ex0(.*);

    ex ex0(.*);

    ex_mem ex_mem0(.*);

    mem mem0(.*, .ram(membus.master));

    mem_wb mem_wb0(.*);

    ctrl ctrl0(.*);

    data_ram data_ram0(.*, .ram(membus.slave));

endmodule
