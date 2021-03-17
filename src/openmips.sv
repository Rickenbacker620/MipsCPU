import project_types::*;

module openmips(
        input logic clk,
        input reset_status_t rst,

        i_instbus.master fetch_interface
    );

    always_comb begin
        fetch_interface.ce <= fetch_inst.ce;
        fetch_interface.addr <= fetch_inst.addr;
        fetch_inst.data <= fetch_interface.data;
    end

    i_regbus fetch_rreg();

    i_instbus fetch_inst();

    i_membus membus();

    jump_t id_jump_o;

    inst_t if_inst_o;
    inst_t id_inst_i;

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
    logic stallreq_from_ex;
    logic stallreq_from_id;
    inst_addr_t ex_link_addr_i;
    logic id_next_in_delayslot_o;

    logic id_now_in_delayslot_o;
    inst_addr_t id_link_addr_o;

    ram_addr_t ex_ramaddr_o;
    ram_addr_t ex_ramaddr_i;

    ram_addr_t mem_ramaddr_i;

    alu_t ex_alu_o;
    alu_t mem_alu_i;





    regfile regfile1(.*, .read(fetch_rreg.slave));

    pc pc0(.*, .rom(fetch_inst.master));

    if_id if_id0(.*);

    id id0(.*, .read(fetch_rreg.master));

    id_ex id_ex0(.*);

    ex ex0(.*);

    ex_mem ex_mem0(.*);

    mem mem0(.*, .ram(membus.master));

    mem_wb mem_wb0(.*);

    ctrl ctrl0(.*);

    data_ram data_ram0(.*, .ram(membus.slave));

endmodule
