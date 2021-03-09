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

        S_PREF = 6'b110011
     } opcode_t;

    typedef enum logic [5:0] {
        R_AND = 6'b100100,
        R_OR = 6'b100101,
        R_XOR = 6'b100110,
        R_NOR = 6'b100111,

        R_SLL = 6'b000000,
        R_SRL = 6'b000010,
        R_SRA = 6'b000011,
        R_SLLV = 6'b000100,
        R_SRLV = 6'b000110,
        R_SRAV = 6'b000111,

        R_MOVN = 6'b001011,
        R_MOVZ = 6'b001010,
        R_MFHI = 6'b010000,
        R_MTHI = 6'b010001,
        R_MFLO = 6'b010010,
        R_MTLO = 6'b010011,

        R_JR = 6'b001000,

        R_SYNC = 6'b001111,

        R_ADDU = 6'b100001

        R_MOVZ = 6'b001010
        R_MOVN = 6'b001011
        R_MFHI = 6'b010000
        R_MTHI = 6'b010001
        R_MFLO = 6'b010010
        R_MTLO = 6'b010011
    } funct_t;

    typedef enum logic [2:0] {
        RES_LOGIC,
        RES_SHIFT,
        RES_ARITH,
        RES_NOP,
        RES_MOVE
    } alu_sel_t;

    typedef enum logic [7:0] {
        OR_OP,
        AND_OP,
        XOR_OP,
        NOR_OP,
        LUI_OP,

        SLL_OP,
        SRL_OP,
        SRA_OP,

        ADD_OP,

        NOP_OP,

        MFHI_OP,
        MFLO_OP,
        MTHI_OP,
        MTLO_OP,
        MOVN_OP,
        MOVZ_OP
    } alu_op_t;

    typedef struct {
        alu_sel_t sel;
        alu_op_t op;
    } alu_t;
endpackage

        // R_SRA_OP = 6'b000011,
        // R_SLLV_OP = 6'b000100,
        // R_SRLV_OP = 6'b000110,
        // R_SRAV_OP = 6'b000111
        // R_SUB_OP = 6'b100010,
        // R_SUBU_OP = 6'b100011,
        // R_AND_OP = 6'b100100,
        // R_OR_OP = 6'b100101,
        // R_XOR_OP = 6'b100110,
        // R_NOR_OP = 6'b100111,
        // R_SLT_OP = 6'b101010,
        // R_SLTU_OP = 6'b101001,

        // R_ADD_OP = 6'b100000,
// I_LW_OP = 6'b100011,
// I_ADDI_OP = 6'b000000,
// DIV = 6'b011010
// DIVU = 6'b011011
// MULT = 6'b011000
// MULTU = 6'b011001
// LHI = 6'b011001
// LLO = 6'b011000
// SLTI = 6'b001010
// SLTIU = 6'b001001
// BEQ = 6'b000100
// BGTZ = 6'b000111
// BLEZ = 6'b000110
// BNE = 6'b000101
// J = 6'b000010
// JAL = 6'b000011
// JALR = 6'b001001
// JR = 6'b001000
// LB = 6'b100000
// LBU = 6'b100100
// LH = 6'b100001
// LHU = 6'b100101
// SB = 6'b101000
// SH = 6'b101001
// SW = 6'b101011
// MFHI = 6'b010000
// MFLO = 6'b010010
// MTHI = 6'b010001
// MTLO = 6'b010011
// TRAP = 6'b011010