import project_types::*;

module ctrl (
    input logic rst,
    input logic id_stallreq,
    input logic ex_stallreq,

    output logic[5:0] stall
);

always_comb begin
    if (rst == RST_ENABLE) begin
        stall = 6'b000000;
    end
    else if (ex_stallreq == 1'b1) begin
        stall = 6'b001111;
    end
    else if (id_stallreq == 1'b1) begin
        stall = 6'b000111;
    end
    else begin
        stall = 6'b000000;
    end
end

endmodule