import project_types::*;
import decode_table::*;

module id(
        input reset_status_t rst,

        i_fetch_rreg.master fetch,

        input inst_t id_inst_i,
        input reg_t ex_wreg_o,
        input reg_t mem_wreg_o,

        output jump_t id_jump_o,

        output alu_t id_alu_o,
        output reg_data_t id_oprd1_o,
        output reg_data_t id_oprd2_o,
        output reg_info_t id_wreg_o
    );

    opcode_t opcode;
    funct_t funct;
    assign opcode = opcode_t'(id_inst_i.data[31:26]);
    assign funct = funct_t'(id_inst_i.data[5:0]);

    inst_addr_t delayslot_addr;
    inst_addr_t return_addr;
    assign delayslot_addr = id_inst_i.addr + 32'h0000_0004;
    assign return_addr = id_inst_i.addr + 32'h0000_0008;

    inst_5bit_t rs, rt, rd, shamt;
    assign rs = id_inst_i.data[25:21];
    assign rt = id_inst_i.data[20:16];
    assign rd = id_inst_i.data[15:11];
    assign shamt = id_inst_i.data[10:6];

    logic [15:0] immi;
    logic [31:0] immexts, immextu, immo;
    assign immi = id_inst_i.data[15:0];
    assign immextu = {16'b0, immi};
    assign immexts = {{16{immi[15]}}, immi};

    valid_status_t instvalid;

    always_comb begin : alu_info
        if (rst == RST_ENABLE)
            id_alu_o = '{default:0};
        else
        case (opcode)
            R_TYPE:
                case (funct)
                    R_AND:
                        id_alu_o = '{RES_LOGIC, AND_OP};
                    R_OR:
                        id_alu_o = '{RES_LOGIC, OR_OP};
                    R_XOR:
                        id_alu_o = '{RES_LOGIC, XOR_OP};
                    R_NOR:
                        id_alu_o = '{RES_LOGIC, NOR_OP};
                    R_SLL,
                    R_SLLV:
                        id_alu_o = '{RES_SHIFT, SLL_OP};
                    R_SRL,
                    R_SRLV:
                        id_alu_o = '{RES_SHIFT, SRL_OP};
                    R_SRA,
                    R_SRAV:
                        id_alu_o = '{RES_SHIFT, SRA_OP};
                    R_SYNC:
                        id_alu_o = '{RES_NOP, NOP_OP};
                    default:
                        id_alu_o = '{default:0};
                endcase
            I_ANDI:
                id_alu_o = '{RES_LOGIC, AND_OP};
            I_ORI,
            I_LUI,
            J_JAL:
                id_alu_o = '{RES_LOGIC, OR_OP};
            I_XORI:
                id_alu_o = '{RES_LOGIC, XOR_OP};
            I_ADDIU:
                id_alu_o = '{RES_ARITH, ADD_OP};
            S_PREF:
                id_alu_o = '{RES_NOP, NOP_OP};
            default:
                id_alu_o = '{default:0};
        endcase
    end


    always_comb begin : read_reg_info
        if (rst == RST_ENABLE) begin
            fetch.r1_info = '{default:0};
            fetch.r2_info = '{default:0};
        end
        else begin
            fetch.r1_info.addr = rs;
            fetch.r2_info.addr = rt;
            case (opcode)
                R_TYPE: case (funct)
                    R_SLL,
                    R_SRL,
                    R_SRA: begin
                        fetch.r1_info.en = REG_DISABLE;
                        fetch.r2_info.en = REG_ENABLE;
                    end
                    default: begin
                        fetch.r1_info.en = REG_ENABLE;
                        fetch.r2_info.en = REG_ENABLE;
                    end
                endcase
                I_ANDI,
                I_ORI,
                I_XORI,
                I_LUI,
                I_ADDIU: begin
                    fetch.r1_info.en = REG_ENABLE;
                    fetch.r2_info.en = REG_DISABLE;
                end
                J_JAL: begin
                    fetch.r1_info.addr = '0;
                    fetch.r1_info.en = REG_ENABLE;
                    fetch.r2_info.en = REG_DISABLE;
                end
                default: begin
                    fetch.r1_info.en = REG_DISABLE;
                    fetch.r2_info.en = REG_DISABLE;
                end
            endcase
        end
    end

    always_comb begin : write_reg_info
        if (rst == RST_ENABLE)
            id_wreg_o = '{default:0};
        else
        case (opcode)
            R_TYPE:
                id_wreg_o = '{REG_ENABLE, rd};
            I_ANDI,
            I_ORI,
            I_XORI,
            I_LUI,
            I_ADDIU:
                id_wreg_o = '{REG_ENABLE, rt};
            J_JAL:
                id_wreg_o = '{REG_ENABLE, 5'b11111};
            default: begin
                id_wreg_o = '{default:0};
            end
        endcase
    end

    always_comb begin : immediate_info
        if (rst == RST_ENABLE)
            immo = '0;
        else
        case (opcode)
            R_TYPE: case (funct)
                R_SLL,
                R_SRL,
                R_SRA:
                    immo = {27'b0, shamt};
                default:
                    immo = '0;
            endcase
            I_ANDI,
            I_ORI,
            I_XORI,
            I_ADDIU:
                immo = immextu;
            I_LUI:
                immo = {immi, 16'b0};
            J_JAL:
                immo = return_addr;
            default:
                immo = '0;
        endcase
    end

    always_comb begin: inst_valid_info
        if (rst == RST_ENABLE)
            instvalid = INVALID;
        else
        case (opcode)
            default:
                instvalid = VALID;
        endcase
    end

    always_comb begin: jump_control
        if (rst == RST_ENABLE)
            id_jump_o = '{default:0};
        else
        case (opcode)
            R_TYPE:
                case (funct)
                    J_JR:
                        id_jump_o = '{JUMP_ENABLE, id_oprd1_o};
                    default:
                        id_jump_o = '{default:0};
                endcase
            I_BEQ: begin
                if (id_oprd1_o == id_oprd2_o)
                    id_jump_o = '{JUMP_ENABLE, delayslot_addr + {immexts[29:0], 2'b00}};
                else
                    id_jump_o = '{default:0};
            end
            I_BNE: begin
                if (id_oprd1_o != id_oprd2_o)
                    id_jump_o = '{JUMP_ENABLE, delayslot_addr + {immexts[29:0], 2'b00}};
                else
                    id_jump_o = '{default:0};
            end
            I_BGTZ: begin
                if (id_oprd1_o > 0)
                    id_jump_o = '{JUMP_ENABLE, delayslot_addr + {immexts[29:0], 2'b00}};
                else
                    id_jump_o = '{default:0};
            end
            J_J,
            J_JAL:
                id_jump_o = '{JUMP_ENABLE, {delayslot_addr[31:28], id_inst_i.data[25:0], 2'b00}};
            default:
                id_jump_o = '{default:0};
        endcase
    end

    always_comb begin: fill_reg_data
        fill_reg(fetch.r1_info, fetch.r1_data, id_oprd1_o);
        fill_reg(fetch.r2_info, fetch.r2_data, id_oprd2_o);
    end


    function automatic void fill_reg(
        ref reg_info_t info,
        ref reg_data_t fetched_data,
        ref reg_data_t data
    );
        if (rst == RST_ENABLE) begin
            data = '0;
        end
        else if ((info.en == REG_ENABLE) && (ex_wreg_o.en == REG_ENABLE) && (ex_wreg_o.addr == info.addr)) begin //fetch ex result before pipline write back
            data = ex_wreg_o.data;
        end
        else if ((info.en == REG_ENABLE) && (mem_wreg_o.en == REG_ENABLE) && (mem_wreg_o.addr == info.addr)) begin //fetch mem result before pipline write back
            data = mem_wreg_o.data;
        end
        else if (info.en == REG_ENABLE) begin //normal fetch
            data = fetched_data;
        end
        else if (info.en == REG_DISABLE) begin //not fetch
            data = immo;
        end
        else begin
            data = '0;
        end
    endfunction

endmodule
