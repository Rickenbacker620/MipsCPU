import project_types::*;

interface i_membus;
    logic we;
    chip_en_t ce;
    ram_addr_t addr;
    ram_data_t write;
    ram_data_t read;

    modport master (
        input read,
        output we, ce, addr, write
    );

    modport slave (
        input we, ce, addr, write,
        output read
    );
endinterface //i_membus


interface i_instbus;
    chip_en_t ce;
    inst_addr_t addr;
    inst_data_t data;

    modport master (
            output ce, addr,
            input data
        );

    modport slave (
            output data,
            input ce, addr
        );
endinterface

interface i_regbus;
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