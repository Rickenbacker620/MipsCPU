import project_types::*;
import decode_table::*;

module ex(
        input reset_status_t rst,

        input alu_t ex_alu_i,
        input reg_data_t ex_oprd1_i,
        input reg_data_t ex_oprd2_i,
        input reg_info_t ex_wreg_i,

        input inst_addr_t ex_link_addr_i,

        output reg_t ex_wreg_o,
        output alu_t ex_alu_o,

        output logic ex_stallreq,

        output ram_addr_t ex_ramaddr_o
    );

    reg_data_t logicres;
    reg_data_t shiftres;
    reg_data_t arithres;
    reg_data_t moveres;

    always_comb begin: logic_opration
        if (rst == RST_ENABLE)
            logicres = '0;
        else case (ex_alu_i.op)
                OR_OP: logicres = ex_oprd1_i | ex_oprd2_i;
                AND_OP: logicres = ex_oprd1_i & ex_oprd2_i;
                XOR_OP: logicres = ex_oprd1_i ^ ex_oprd2_i;
                default: logicres = '0;
            endcase
        end

    always_comb begin: shift_operation
        if (rst == RST_ENABLE)
            shiftres = '0;
        else case (ex_alu_i.op)
                SLL_OP: shiftres = ex_oprd2_i << ex_oprd1_i[4:0];
                SRL_OP: shiftres = ex_oprd2_i >> ex_oprd1_i[4:0];
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

    always_comb begin : load_store_operation
        if (rst == RST_ENABLE) begin
            ex_ramaddr_o = '0;
            ex_alu_i = ex_alu_o;
        end
        else case (ex_alu_i.op)
                LB_OP: ex_ramaddr_o = ex_oprd1_i + ex_oprd2_i;
                LW_OP: ex_ramaddr_o = ex_oprd1_i + ex_oprd2_i;
                SB_OP: ex_ramaddr_o = ex_oprd1_i + ex_oprd2_i;
                SW_OP: ex_ramaddr_o = ex_oprd1_i + ex_oprd2_i;
                default: ex_ramaddr_o = '0;
            endcase
    end

    always_comb begin: fill_wreg
        ex_wreg_o.en = ex_wreg_i.en;
        ex_wreg_o.addr = ex_wreg_i.addr;
        case (ex_alu_i.sel)
            RES_LOGIC: ex_wreg_o.data = logicres;
            RES_SHIFT: ex_wreg_o.data = shiftres;
            RES_ARITH: ex_wreg_o.data = arithres;
            RES_JUMP: ex_wreg_o.data = ex_link_addr_i;
            default: ex_wreg_o.data = '0;
        endcase
    end

endmodule
