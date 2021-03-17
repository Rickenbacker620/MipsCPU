import project_types::*;
import decode_table::*;

module id(
        input reset_status_t rst,

        i_regbus.master read,

        input pc_t id_pc_i,
        input inst_t id_inst_i,
        input reg_t ex_wreg_o,
        input reg_t mem_wreg_o,

        input logic id_in_delayslot_i,

        output alu_t id_alu_o,
        output reg_data_t id_oprd1_o,
        output reg_data_t id_oprd2_o,
        output reg_info_t id_wreg_o,

        output jump_t id_jumpreq,

        output logic id_stallreq,

        output logic id_next_in_delayslot_o,

        output logic id_now_in_delayslot_o,

        output pc_t id_link_addr_o
    );

    opcode_t opcode;
    funct_t funct;
    assign opcode = opcode_t'(id_inst_i[31:26]);
    assign funct = funct_t'(id_inst_i[5:0]);

    pc_t delayslot_addr;
    pc_t return_addr;
    assign delayslot_addr = id_pc_i + 32'h0000_0004;
    assign return_addr = id_pc_i + 32'h0000_0008;

    inst_5bit_t rs, rt, rd, shamt;
    assign rs = id_inst_i[25:21];
    assign rt = id_inst_i[20:16];
    assign rd = id_inst_i[15:11];
    assign shamt = id_inst_i[10:6];

    logic [15:0] immi;
    logic [31:0] immexts, immextu, immo, shamtext;
    assign immi = id_inst_i[15:0];
    assign immextu = {16'b0, immi};
    assign immexts = {{16{immi[15]}}, immi};
    assign shamtext = {27'b0, shamt};

    valid_status_t instvalid;

    always_comb begin
        if (rst == RST_ENABLE) begin
            id_alu_o = '{default:0};
            id_wreg_o = '{default:0};
            read.r1_info = '{default:0};
            read.r2_info = '{default:0};
            immo = '0;
        end
        else begin
            instvalid = VALID;
            id_jumpreq = '{default:0};
            id_link_addr_o = '0;
        case (opcode)
            R_TYPE: begin
                case (funct)
                    J_JR: begin
                        id_alu_o = '{default:0};
                        id_wreg_o = '{default:0};
                        read.r1_info = '{REG_ENABLE, rs};
                        read.r2_info = '{default:0};
                        immo = '0;
                        id_jumpreq = '{JUMP_ENABLE, id_oprd1_o};
                    end
                    R_AND: begin
                        id_alu_o = '{RES_LOGIC, AND_OP};
                        id_wreg_o = '{REG_ENABLE, rd};
                        read.r1_info = '{REG_ENABLE, rs};
                        read.r2_info = '{REG_ENABLE, rt};
                        immo = '0;
                    end
                    R_OR: begin
                        id_alu_o = '{RES_LOGIC, OR_OP};
                        id_wreg_o = '{REG_ENABLE, rd};
                        read.r1_info = '{REG_ENABLE, rs};
                        read.r2_info = '{REG_ENABLE, rt};
                        immo = '0;
                    end
                    R_XOR: begin
                        id_alu_o = '{RES_LOGIC, XOR_OP};
                        id_wreg_o = '{REG_ENABLE, rd};
                        read.r1_info = '{REG_ENABLE, rs};
                        read.r2_info = '{REG_ENABLE, rt};
                        immo = '0;
                    end
                    R_SLL: begin
                        id_alu_o = '{RES_SHIFT, SLL_OP};
                        id_wreg_o = '{REG_ENABLE, rd};
                        read.r1_info = '{default:0};
                        read.r2_info = '{REG_ENABLE, rt};
                        immo = shamtext;
                    end
                    R_SRL: begin
                        id_alu_o = '{RES_SHIFT, SRL_OP};
                        id_wreg_o = '{REG_ENABLE, rd};
                        read.r1_info = '{default:0};
                        read.r2_info = '{REG_ENABLE, rt};
                        immo = shamtext;
                    end
                    default: begin
                        id_alu_o = '{default:0};
                        id_wreg_o = '{default:0};
                        read.r1_info = '{default:0};
                        read.r2_info = '{default:0};
                        immo = '0;
                    end
                endcase
            end
            I_LB: begin
                id_alu_o = '{RES_LOAD_STORE, LB_OP};
                id_wreg_o = '{REG_ENABLE, rt};
                read.r1_info = '{REG_ENABLE, rs};
                read.r2_info = '{default:0};
                immo = immexts;
            end
            I_LW: begin
                id_alu_o = '{RES_LOAD_STORE, LW_OP};
                id_wreg_o = '{REG_ENABLE, rt};
                read.r1_info = '{REG_ENABLE, rs};
                read.r2_info = '{default:0};
                immo = immexts;
            end
            I_ANDI: begin
                id_alu_o = '{RES_LOGIC, AND_OP};
                id_wreg_o = '{REG_ENABLE, rt};
                read.r1_info = '{REG_ENABLE, rs};
                read.r2_info = '{default:0};
                immo = immextu;
            end
            I_ORI: begin
                id_alu_o = '{RES_LOGIC, OR_OP};
                id_wreg_o = '{REG_ENABLE, rt};
                read.r1_info = '{REG_ENABLE, rs};
                read.r2_info = '{default:0};
                immo = immextu;
            end
            I_LUI: begin
                id_alu_o = '{RES_LOGIC, OR_OP};
                id_wreg_o = '{REG_ENABLE, rt};
                read.r1_info = '{REG_ENABLE, rs};
                read.r2_info = '{default:0};
                immo = {immi, 16'b0};
            end
            I_XORI: begin
                id_alu_o = '{RES_LOGIC, XOR_OP};
                id_wreg_o = '{REG_ENABLE, rt};
                read.r1_info = '{REG_ENABLE, rs};
                read.r2_info = '{default:0};
                immo = immextu;
            end
            I_ADDIU: begin
                id_alu_o = '{RES_ARITH, ADD_OP};
                id_wreg_o = '{REG_ENABLE, rt};
                read.r1_info = '{REG_ENABLE, rs};
                read.r2_info = '{default:0};
                immo = immextu;
            end
            I_BEQ: begin
                id_alu_o = '{RES_JUMP, BEQ_OP};
                id_wreg_o = '{default:0};
                read.r1_info = '{REG_ENABLE, rs};
                read.r2_info = '{REG_ENABLE, rt};
                immo = '0;
                if (id_oprd1_o == id_oprd2_o)
                    id_jumpreq = '{JUMP_ENABLE, delayslot_addr + {immexts[29:0], 2'b00}};
            end
            I_BNE: begin
                id_wreg_o = '{default:0};
                read.r1_info = '{REG_ENABLE, rs};
                read.r2_info = '{REG_ENABLE, rt};
                if (id_oprd1_o != id_oprd2_o)
                    id_jumpreq = '{JUMP_ENABLE, delayslot_addr + {immexts[29:0], 2'b00}};
            end
            I_BGTZ: begin
                id_wreg_o = '{default:0};
                read.r1_info = '{REG_ENABLE, rs};
                read.r2_info = '{REG_ENABLE, rt};
                if (id_oprd1_o > 0)
                    id_jumpreq = '{JUMP_ENABLE, delayslot_addr + {immexts[29:0], 2'b00}};
            end
            J_J: begin
                id_wreg_o = '{default:0};
                read.r1_info = '{REG_ENABLE, rs};
                read.r2_info = '{REG_ENABLE, rt};
                id_jumpreq = '{JUMP_ENABLE, {delayslot_addr[31:28], id_inst_i[25:0], 2'b00}};
            end
            J_JAL: begin
                id_alu_o = '{RES_JUMP, JAL_OP};
                id_wreg_o = '{REG_ENABLE, 5'b11111};
                read.r1_info = '{default:0};
                read.r2_info = '{default:0};
                id_link_addr_o = return_addr;
                id_jumpreq = '{JUMP_ENABLE, {delayslot_addr[31:28], id_inst_i[25:0], 2'b00}};
            end
            default: begin
                id_alu_o = '{default:0};
                id_wreg_o = '{default:0};
                read.r1_info = '{default:0};
                read.r2_info = '{default:0};
                immo = '0;
            end
        endcase
        end
    end

    always_comb begin
        fill_reg(read.r1_info, read.r1_data, id_oprd1_o);
        fill_reg(read.r2_info, read.r2_data, id_oprd2_o);
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
