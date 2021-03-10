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
    logic [31:0] immexts, immextu, immo, shamtext;
    assign immi = id_inst_i.data[15:0];
    assign immextu = {16'b0, immi};
    assign immexts = {{16{immi[15]}}, immi};
    assign shamtext = {27'b0, shamt};

    valid_status_t instvalid;

    always_comb begin
        if (rst == RST_ENABLE) begin
            id_alu_o = '{default:0};
            id_wreg_o = '{default:0};
            fetch.r1_info = '{default:0};
            fetch.r2_info = '{default:0};
            immo = '0;
        end
        else begin
            instvalid = VALID;
            id_jump_o = '{default:0};
        case (opcode)
            R_TYPE: begin
                case (funct)
                    J_JR: begin
                        id_alu_o = '{default:0};
                        id_wreg_o = '{default:0};
                        fetch.r1_info = '{default:0};
                        fetch.r2_info = '{default:0};
                        immo = '0;
                        id_jump_o = '{JUMP_ENABLE, id_oprd1_o};
                    end
                    R_AND: begin
                        id_alu_o = '{RES_LOGIC, AND_OP};
                        id_wreg_o = '{REG_ENABLE, rd};
                        fetch.r1_info = '{REG_ENABLE, rs};
                        fetch.r2_info = '{REG_ENABLE, rt};
                        immo = '0;
                    end
                    R_OR: begin
                        id_alu_o = '{RES_LOGIC, OR_OP};
                        id_wreg_o = '{REG_ENABLE, rd};
                        fetch.r1_info = '{REG_ENABLE, rs};
                        fetch.r2_info = '{REG_ENABLE, rt};
                        immo = '0;
                    end
                    R_XOR: begin
                        id_alu_o = '{RES_LOGIC, XOR_OP};
                        id_wreg_o = '{REG_ENABLE, rd};
                        fetch.r1_info = '{REG_ENABLE, rs};
                        fetch.r2_info = '{REG_ENABLE, rt};
                        immo = '0;
                    end
                    R_NOR: begin
                        id_alu_o = '{RES_LOGIC, NOR_OP};
                        id_wreg_o = '{REG_ENABLE, rd};
                        fetch.r1_info = '{REG_ENABLE, rs};
                        fetch.r2_info = '{REG_ENABLE, rt};
                        immo = '0;
                    end
                    R_SLL: begin
                        id_alu_o = '{RES_SHIFT, SLL_OP};
                        id_wreg_o = '{REG_ENABLE, rd};
                        fetch.r1_info = '{default:0};
                        fetch.r2_info = '{REG_ENABLE, rt};
                        immo = shamtext;
                    end
                    R_SLLV: begin
                        id_alu_o = '{RES_SHIFT, SLL_OP};
                        id_wreg_o = '{REG_ENABLE, rd};
                        fetch.r1_info = '{REG_ENABLE, rs};
                        fetch.r2_info = '{REG_ENABLE, rt};
                        immo = '0;
                    end
                    R_SRL: begin
                        id_alu_o = '{RES_SHIFT, SRL_OP};
                        id_wreg_o = '{REG_ENABLE, rd};
                        fetch.r1_info = '{default:0};
                        fetch.r2_info = '{REG_ENABLE, rt};
                        immo = shamtext;
                    end
                    R_SRLV: begin
                        id_alu_o = '{RES_SHIFT, SRL_OP};
                        id_wreg_o = '{REG_ENABLE, rd};
                        fetch.r1_info = '{REG_ENABLE, rs};
                        fetch.r2_info = '{REG_ENABLE, rt};
                        immo = '0;
                    end
                    R_SRA: begin
                        id_alu_o = '{RES_SHIFT, SRA_OP};
                        id_wreg_o = '{REG_ENABLE, rd};
                        fetch.r1_info = '{default:0};
                        fetch.r2_info = '{REG_ENABLE, rt};
                        immo = shamtext;
                    end
                    R_SRAV: begin
                        id_alu_o = '{RES_SHIFT, SRA_OP};
                        id_wreg_o = '{REG_ENABLE, rd};
                        fetch.r1_info = '{REG_ENABLE, rs};
                        fetch.r2_info = '{REG_ENABLE, rt};
                        immo = '0;
                    end
                    R_SYNC: begin
                        id_alu_o = '{RES_NOP, NOP_OP};
                        id_wreg_o = '{REG_ENABLE, rd};
                        fetch.r1_info = '{REG_ENABLE, rs};
                        fetch.r2_info = '{REG_ENABLE, rt};
                        immo = '0;
                    end
                    R_MFHI: begin
                        id_alu_o = '{RES_MOVE, MFHI_OP};
                        id_wreg_o = '{REG_ENABLE, rd};
                        fetch.r1_info = '{default:0};
                        fetch.r2_info = '{default:0};
                        immo = '0;
                    end
                    R_MFLO: begin
                        id_alu_o = '{RES_MOVE, MFLO_OP};
                        id_wreg_o = '{REG_ENABLE, rd};
                        fetch.r1_info = '{default:0};
                        fetch.r2_info = '{default:0};
                        immo = '0;
                    end
                    R_MTHI: begin
                        id_alu_o = '{RES_MOVE, MTHI_OP};
                        id_wreg_o = '{REG_ENABLE, 5'b00000};
                        fetch.r1_info = '{REG_ENABLE, rs};
                        fetch.r2_info = '{default:0};
                        immo = '0;
                    end
                    R_MTLO: begin
                        id_alu_o = '{RES_MOVE, MTLO_OP};
                        id_wreg_o = '{REG_ENABLE, 5'b00000};
                        fetch.r1_info = '{REG_ENABLE, rs};
                        fetch.r2_info = '{default:0};
                        immo = '0;
                    end
                    R_MOVN: begin
                        id_alu_o = '{RES_MOVE, MOVN_OP};
                        fetch.r1_info = '{REG_ENABLE, rs};
                        fetch.r2_info = '{REG_ENABLE, rt};
                        immo = '0;
                        if (id_oprd2_o != 0) begin
                            id_wreg_o = '{REG_ENABLE, rd};
                        end
                        else begin
                            id_wreg_o = '{default:0};
                        end
                    end
                    R_MOVZ: begin
                        id_alu_o = '{RES_MOVE, MOVZ_OP};
                        fetch.r1_info = '{REG_ENABLE, rs};
                        fetch.r2_info = '{REG_ENABLE, rt};
                        immo = '0;
                        if (id_oprd2_o == 0) begin
                            id_wreg_o = '{REG_ENABLE, rd};
                        end
                        else begin
                            id_wreg_o = '{default:0};
                        end
                    end
                    default: begin
                        id_alu_o = '{default:0};
                        id_wreg_o = '{default:0};
                        fetch.r1_info = '{default:0};
                        fetch.r2_info = '{default:0};
                        immo = '0;
                    end
                endcase
            end
            I_ANDI: begin
                id_alu_o = '{RES_LOGIC, AND_OP};
                id_wreg_o = '{REG_ENABLE, rt};
                fetch.r1_info = '{REG_ENABLE, rs};
                fetch.r2_info = '{default:0};
                immo = immextu;
            end
            I_ORI: begin
                id_alu_o = '{RES_LOGIC, OR_OP};
                id_wreg_o = '{REG_ENABLE, rt};
                fetch.r1_info = '{REG_ENABLE, rs};
                fetch.r2_info = '{default:0};
                immo = immextu;
            end
            I_LUI: begin
                id_alu_o = '{RES_LOGIC, OR_OP};
                id_wreg_o = '{REG_ENABLE, rt};
                fetch.r1_info = '{REG_ENABLE, rs};
                fetch.r2_info = '{default:0};
                immo = {immi, 16'b0};
            end
            J_JAL: begin
                id_alu_o = '{RES_LOGIC, OR_OP};
                id_wreg_o = '{REG_ENABLE, 5'b11111};
                fetch.r1_info = '{REG_ENABLE, 5'b00000};
                fetch.r2_info = '{default:0};
                immo = return_addr;
            end
            I_XORI: begin
                id_alu_o = '{RES_LOGIC, XOR_OP};
                id_wreg_o = '{REG_ENABLE, rt};
                fetch.r1_info = '{REG_ENABLE, rs};
                fetch.r2_info = '{default:0};
                immo = immextu;
            end
            I_ADDIU: begin
                id_alu_o = '{RES_ARITH, ADD_OP};
                id_wreg_o = '{REG_ENABLE, rt};
                fetch.r1_info = '{REG_ENABLE, rs};
                fetch.r2_info = '{default:0};
                immo = immextu;
            end
            S_PREF: begin
                id_alu_o = '{RES_NOP, NOP_OP};
                id_wreg_o = '{default:0};
                fetch.r1_info = '{default:0};
                fetch.r2_info = '{default:0};
                immo = '0;
            end
            I_BEQ: begin
                // id_alu_o = '{RES_JUMP, BEQ_OP};
                id_wreg_o = '{default:0};
                fetch.r1_info = '{REG_ENABLE, rs};
                fetch.r2_info = '{REG_ENABLE, rt};
                immo = '0;
                if (id_oprd1_o == id_oprd2_o)
                    id_jump_o = '{JUMP_ENABLE, delayslot_addr + {immexts[29:0], 2'b00}};
            end
            I_BNE: begin
                id_wreg_o = '{default:0};
                fetch.r1_info = '{REG_ENABLE, rs};
                fetch.r2_info = '{REG_ENABLE, rt};
                if (id_oprd1_o != id_oprd2_o)
                    id_jump_o = '{JUMP_ENABLE, delayslot_addr + {immexts[29:0], 2'b00}};
            I_BGTZ:
                id_wreg_o = '{default:0};
                fetch.r1_info = '{REG_ENABLE, rs};
                fetch.r2_info = '{REG_ENABLE, rt};
                if (id_oprd1_o > 0)
                    id_jump_o = '{JUMP_ENABLE, delayslot_addr + {immexts[29:0], 2'b00}};
            end
            J_J: begin
                id_wreg_o = '{default:0};
                fetch.r1_info = '{REG_ENABLE, rs};
                fetch.r2_info = '{REG_ENABLE, rt};
                id_jump_o = '{JUMP_ENABLE, {delayslot_addr[31:28], id_inst_i.data[25:0], 2'b00}};
            end
            J_JAL: begin
                id_wreg_o = '{default:0};
                fetch.r1_info = '{REG_ENABLE, rs};
                fetch.r2_info = '{REG_ENABLE, rt};
                id_jump_o = '{JUMP_ENABLE, {delayslot_addr[31:28], id_inst_i.data[25:0], 2'b00}};
            end
            default: begin
                id_alu_o = '{default:0};
                id_wreg_o = '{default:0};
                fetch.r1_info = '{default:0};
                fetch.r2_info = '{default:0};
                immo = '0;
            end
        endcase
        end
    end

    always_comb begin
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
