import project_types::*;
import decode_table::*;

module ex(
        input reset_status_t rst,

        input alu_t ex_alu_i,
        input reg_data_t ex_oprd1_i,
        input reg_data_t ex_oprd2_i,
        input reg_info_t ex_wreg_i,

        input reg_data_t hilo_hi_o,
        input reg_data_t hilo_lo_o,

        input hilo_t mem_hilo_o,
        input hilo_t wb_hilo_o,

        input inst_addr_t ex_link_addr_i,

        output reg_t ex_wreg_o,
        output hilo_t ex_hilo_o,

        output logic stallreq_from_ex

    );

    reg_data_t logicres;
    reg_data_t shiftres;
    reg_data_t arithres;
    reg_data_t moveres;
    reg_data_t HI;
    reg_data_t LO;

    always_comb begin: logic_opration
        if (rst == RST_ENABLE)
            logicres = '0;
        else case (ex_alu_i.op)
                OR_OP: logicres = ex_oprd1_i | ex_oprd2_i;
                AND_OP: logicres = ex_oprd1_i & ex_oprd2_i;
                XOR_OP: logicres = ex_oprd1_i ^ ex_oprd2_i;
                NOR_OP: logicres = ~(ex_oprd1_i | ex_oprd2_i);
                default: logicres = '0;
            endcase
        end

    always_comb begin: shift_operation
        if (rst == RST_ENABLE)
            shiftres = '0;
        else case (ex_alu_i.op)
                SLL_OP: shiftres = ex_oprd2_i << ex_oprd1_i[4:0];
                SRL_OP: shiftres = ex_oprd2_i >> ex_oprd1_i[4:0];
                SRA_OP: shiftres = signed'(ex_oprd2_i) >>> ex_oprd1_i[4:0];
                default: shiftres = '0;
            endcase
        end

    always_comb begin: arithmetic_operation
        if (rst == RST_ENABLE)
            arithres = '0;
        else case (ex_alu_i.op)
                ADD_OP: arithres = ex_oprd1_i + ex_oprd2_i;
                default: arithres = '0;
            endcase
        end

    always_comb begin : HILO_operation
        if (rst == RST_ENABLE) begin
            HI = '0;
            LO = '0;
        end
        else if (mem_hilo_o.en == REG_ENABLE) begin
            HI = mem_hilo_o.hi;
            LO = mem_hilo_o.lo;
        end
        else if (wb_hilo_o.en == REG_ENABLE) begin
            HI = wb_hilo_o.hi;
            LO = wb_hilo_o.lo;
        end
        else begin
            HI = hilo_hi_o;
            LO = hilo_lo_o;
        end
    end

    always_comb begin : MOVE_operations
        if (rst == RST_ENABLE)
            moveres = '0;
        else begin
            moveres = '0;
            case (ex_alu_i.op)
                MFHI_OP: moveres = HI;
                MFLO_OP: moveres = LO;
                MOVZ_OP: moveres = ex_oprd1_i;
                MOVN_OP: moveres = ex_oprd1_i;
                default: begin
                end
            endcase
        end
    end

    always_comb begin: fill_wreg
        ex_wreg_o.en = ex_wreg_i.en;
        ex_wreg_o.addr = ex_wreg_i.addr;
        case (ex_alu_i.sel)
            RES_LOGIC: ex_wreg_o.data = logicres;
            RES_SHIFT: ex_wreg_o.data = shiftres;
            RES_ARITH: ex_wreg_o.data = arithres;
            RES_MOVE: ex_wreg_o.data = moveres;
            RES_JUMP: ex_wreg_o.data = ex_link_addr_i;
            default: ex_wreg_o.data = '0;
        endcase
    end

    always_comb begin : fill_HILO
        if (rst == RST_ENABLE) begin
            ex_hilo_o = '{default:0};
        end else if (ex_alu_i.op == MTHI_OP) begin
            ex_hilo_o = '{REG_ENABLE, ex_oprd1_i, LO};
        end else if (ex_alu_i.op == MTLO_OP) begin
            ex_hilo_o = '{REG_ENABLE, HI, ex_oprd1_i};
        end else begin
            ex_hilo_o = '{default:0};
        end
    end

endmodule
