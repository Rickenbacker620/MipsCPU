import project_types::*;

module openmips(
        input logic clk,
        input reset_status_t rst,

        i_fetch_inst.master fetch_interface
    );

    always_comb begin
        fetch_interface.en <= fetch_inst.en;
        fetch_interface.addr <= fetch_inst.addr;
        fetch_inst.data <= fetch_interface.data;
    end

    i_fetch_rreg fetch_rreg();

    i_fetch_inst fetch_inst();

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
    reg_t wb_wreg_i;


    regfile regfile1(.*, .read(fetch_rreg.slave));

    pc pc0(.*, .fetch(fetch_inst.master));

    if_id if_id0(.*);

    id id0(.*, .fetch(fetch_rreg.master));

    id_ex id_ex0(.*);

    ex ex0(.*);

    ex_mem ex_mem0(.*);

    mem mem0(.*);

    mem_wb mem_wb0(.*);

endmodule
