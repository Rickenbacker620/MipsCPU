import project_types::*;

module inst_rom (
        i_instbus.slave rom
    );

    inst_data_t inst_mem [0: 131071 - 1];

    initial
        $readmemh("C:/Users/paras/Documents/Projects/MipsCPU/mock/rom.data", inst_mem);

    always_comb begin
        if (rom.ce == CHIP_DISABLE) begin
            rom.data = '0;
        end
        else begin
            rom.data = inst_mem[rom.addr[17 + 1: 2]];
        end
    end

endmodule
