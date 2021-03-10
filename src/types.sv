package project_types;
    //status
    typedef enum logic {
        VALID = 1'b0,
        INVALID = 1'b1
    } valid_status_t;

    typedef enum logic {
        RST_ENABLE = 1'b1,
        RST_DISABLE = 1'b0
    } reset_status_t;

    //instruction types
    typedef enum logic {
        CHIP_ENABLE = 1'b1,
        CHIP_DISABLE = 1'b0
    } chip_en_t;

    typedef logic [31:0] inst_addr_t;
    typedef logic [31:0] inst_data_t;

    typedef struct {
        chip_en_t en;
        inst_addr_t addr;
    } inst_info_t;

    typedef struct {
        inst_addr_t addr;
        inst_data_t data;
    } inst_t;

    //register types
    typedef enum logic {
        REG_ENABLE = 1'b1,
        REG_DISABLE = 1'b0
    } reg_en_t;

    typedef logic [4:0] reg_addr_t;
    typedef logic [31:0] reg_data_t;

    typedef struct {
        reg_en_t en;
        reg_addr_t addr;
    } reg_info_t;

    typedef struct {
        reg_en_t en;
        reg_addr_t addr;
        reg_data_t data;
    } reg_t;

    typedef struct {
        reg_en_t en;
        reg_data_t hi;
        reg_data_t lo;
    } hilo_t;

    //control types
    typedef enum logic {
        JUMP_ENABLE = 1'b1,
        JUMP_DISABLE = 1'b0
    } jump_status_t;

    typedef struct {
        jump_status_t en;
        inst_addr_t addr;
    } jump_t;
endpackage