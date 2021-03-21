package decode_table;

    typedef logic [5:0] inst_6bit_t;
    typedef logic [4:0] inst_5bit_t;

    typedef enum logic [5:0] {
        R_TYPE = 6'b000000,
        I_ANDI = 6'b001100,
        I_ORI = 6'b001101,
        I_XORI = 6'b001110,
        I_LUI = 6'b001111,

        I_ADDIU = 6'b001001,

        I_BEQ = 6'b000100,
        I_BNE = 6'b000101,
        I_BGTZ = 6'b000111,

        J_J = 6'b000010,
        J_JR = 6'b001000,
        J_JAL = 6'b000011,

        I_LB = 6'b100000,
        I_LW = 6'b100011,

        I_SB = 6'b101000,
        I_SW = 6'b101011
     } opcode_t;

    typedef enum logic [5:0] {
        R_AND = 6'b100100,
        R_OR = 6'b100101,
        R_XOR = 6'b100110,

        R_SLL = 6'b000000,
        R_SRL = 6'b000010,

        R_JR = 6'b001000,

        R_ADDU = 6'b100001
    } funct_t;

    typedef enum logic [2:0] {
        RES_LOGIC,
        RES_SHIFT,
        RES_ARITH,
        RES_JUMP,
        RES_LOAD_STORE
    } alu_sel_t;

    typedef enum logic [7:0] {
        OR_OP,
        AND_OP,
        XOR_OP,
        NOR_OP,
        LUI_OP,

        SLL_OP,
        SRL_OP,

        ADD_OP,

        JAL_OP,
        BEQ_OP,

        LW_OP,
        LB_OP,
        SB_OP,
        SW_OP
    } alu_op_t;

    typedef struct {
        alu_sel_t sel;
        alu_op_t op;
    } alu_t;

endpackage