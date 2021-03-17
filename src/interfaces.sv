import project_types::*;


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