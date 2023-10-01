`default_nettype none

module cdc_2_phase
    #
    (
        parameter int G_STAGES = 2,
        parameter int G_WIDTH /*verilator public*/ = 4
    )

    (
        input logic i_clk_A,
        input logic i_rst_A,
        input logic i_valid_A,
        input logic [G_WIDTH - 1 : 0] i_data_A,
        output logic o_ready_A,
        output logic [G_WIDTH - 1 : 0] o_data_A,

        input logic i_clk_B,
        input logic i_rst_B,
        output logic o_valid_B,
        output logic [G_WIDTH - 1 : 0] o_data_B,
        output logic f_ready_A_prev,
        output logic f_valid_B_prev
    );

    logic w_ready;
    logic w_req;
    logic w_ack;

    logic r_ack_sync;
    logic r_req_sync;

    assign w_ready = (w_req == r_ack_sync) ? 1'b1 : 1'b0;
    assign o_data_A = i_data_A;

    always_ff @(posedge i_clk_A) begin : handshake_A
        if(i_rst_A) begin
            w_req <= 1'b0;
            o_ready_A <= 1'b0;
            f_ready_A_prev <= 1'b0;
        end else begin
            o_ready_A <= w_ready;
            f_ready_A_prev <= o_ready_A;

            if(i_valid_A && w_ready)
                w_req <= ~w_req;
        end
     end

    ff_synchronizer #(.G_STAGES(G_STAGES)) sync_chain_B2A (
        .i_clk(i_clk_A),
        .i_rst(i_rst_A),
        .i_async(w_ack),
        .o_sync(r_ack_sync)
    );

    always_ff @(posedge i_clk_B) begin : handshake_B
        if(i_rst_B) begin
            w_ack <= 1'b0;
            o_valid_B <= 1'b0;
            f_valid_B_prev <= 1'b0;
        end else begin
            f_valid_B_prev <= o_valid_B;

            if (w_ack != r_req_sync) begin
                w_ack <= ~w_ack;
                o_valid_B <= 1'b1;
                o_data_B <= o_data_A;
            end else 
                o_valid_B <= 1'b0; 
        end
    end

    ff_synchronizer #(.G_STAGES(G_STAGES)) sync_chain_A2B (
        .i_clk(i_clk_B),
        .i_rst(i_rst_B),
        .i_async(w_req),
        .o_sync(r_req_sync)
    );

endmodule : cdc_2_phase
