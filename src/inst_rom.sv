import project_types::*;

module inst_rom (
        i_fetch_inst.slave inst
    );

    inst_data_t inst_mem [0: 131071 - 1];

    initial
        $readmemh("C:/Users/Admin/Desktop/openmips/mock/rom.data", inst_mem);

    always_comb begin
        if (inst.en == CHIP_DISABLE) begin
            inst.data = '0;
        end
        else begin
            inst.data = inst_mem[inst.addr[17 + 1: 2]];
        end
    end

endmodule
