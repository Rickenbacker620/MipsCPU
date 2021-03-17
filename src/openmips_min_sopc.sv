import project_types::*;

module openmips_min_sopc (
    input wire clk,
    input reset_status_t rst
);

  i_fetch_inst fetch_out ();

  openmips openmips0 (
      .clk(clk),
      .rst(rst),

      .fetch_interface(fetch_out.master)
  );

  inst_rom inst_rom0 (.rom(fetch_out.slave));

endmodule
