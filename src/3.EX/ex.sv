import project_types::*;
import decode_table::*;

module ex(
        input reset_status_t rst,

        input alu_t ex_alu_i,
        input reg_data_t ex_oprd1_i,
        input reg_data_t ex_oprd2_i,
        input reg_info_t ex_wreg_i,

        output reg_t ex_wreg_o
    );

    reg_data_t logicres;
    reg_data_t shiftres;
    reg_data_t arithres;

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

    always_comb begin: fill_wreg
        ex_wreg_o.en = ex_wreg_i.en;
        ex_wreg_o.addr = ex_wreg_i.addr;
        case (ex_alu_i.sel)
            RES_LOGIC: ex_wreg_o.data = logicres;
            RES_SHIFT: ex_wreg_o.data = shiftres;
            RES_ARITH: ex_wreg_o.data = arithres;
            default: ex_wreg_o.data = '0;
        endcase
    end
endmodule
