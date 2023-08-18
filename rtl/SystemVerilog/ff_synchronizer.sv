`default_nettype none

module ff_synchronizer
    #
    (
        parameter int G_STAGES = 2
    )

    (
        input logic  i_clk,
        input logic  i_rst,
        input logic  i_async,
        output logic o_sync
    );

    // In Xilinx, use ASYNC_REG attribute to instruct the placer
    // to place the ffs in synchronization chain to maximize MTBF.

    // Also assign SHRE_EXTRACT attribute to "NO"
    // to instruct the tool not to translate the FF chain in SRL plus FF.

    logic [G_STAGES - 1 : 0] r_sync;

    always_ff @(posedge i_clk) begin : sync_chain
        if(i_rst) begin
            r_sync <= '0;
        end else begin
            r_sync <= {r_sync[G_STAGES - 2 : 0], i_async};
        end
    end

    assign o_sync = r_sync[G_STAGES - 1];
endmodule : ff_synchronizer
