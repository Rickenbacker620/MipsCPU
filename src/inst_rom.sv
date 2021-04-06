import project_types::*;

module inst_rom (
    input chip_status_t ce,
    input inst_addr_t pc,

    output inst_t inst
);

    // inst_t inst_mem [0: 131071 - 1];
    inst_t inst_mem [0: 1234 - 1];

    initial
        $readmemh("C:/Users/paras/Documents/Projects/MipsCPU/mock/rom.data", inst_mem);

    always_comb begin
        if (ce == CHIP_DISABLE) begin
            inst = '0;
        end
        else begin
            inst = inst_mem[pc[17 + 1: 2]];
        end
    end

endmodule
