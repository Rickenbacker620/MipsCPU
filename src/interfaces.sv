import project_types::*;

interface i_fetch_inst;
    chip_en_t en;
    inst_addr_t addr;
    inst_data_t data;

    modport master (
            output en, addr,
            input data
        );

    modport slave (
            output data,
            input en, addr
        );
endinterface

interface i_fetch_rreg;
    reg_info_t r1_info;
    reg_info_t r2_info;
    reg_data_t r1_data;
    reg_data_t r2_data;

    modport master (
        input r1_data, r2_data,
        output r1_info, r2_info
    );

    modport slave (
        input r1_info, r2_info,
        output r1_data, r2_data
    );
endinterface