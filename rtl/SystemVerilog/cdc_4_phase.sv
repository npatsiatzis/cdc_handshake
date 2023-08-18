`default_nettype none
/* verilator lint_off MULTITOP */
module cdc_4_phase
    #
    (
        parameter int G_STAGES = 2,
        parameter int G_WIDTH = 4
    )

    (
        input logic i_clk_A,
        input logic i_rst_A,
        input logic i_ready_A,
        input logic [G_WIDTH - 1 : 0] i_data_A,
        output logic o_busy_A,

        input logic i_clk_B,
        input logic i_rst_B,
        output logic o_busy_B,
        output logic [G_WIDTH - 1 : 0] o_data_B
    );

    typedef enum logic [1 : 0] {REQ_ASSERT,REQ_DEASSERT,END_TRANSACTION} states_tx_t;
    typedef enum logic {ACK_ASSERT,ACK_DEASSERT} states_rx_t;

    states_tx_t state_TX;
    states_rx_t state_RX;

    logic r_req;
    logic r_ack;
    logic r_ack_sync;
    logic r_req_sync;



    ff_synchronizer #(.G_STAGES(G_STAGES)) sync_chain_B2A (
        .i_clk(i_clk_A),
        .i_rst(i_rst_A),
        .i_async(r_ack),
        .o_sync(r_ack_sync)
    );

    always_ff @(posedge i_clk_A) begin : handshake_A
        if(i_rst_A) begin
            state_TX <= REQ_ASSERT;
            o_busy_A <= 1'b1;
            r_req <= 1'b0;
        end else begin
            case (state_TX)
                REQ_ASSERT : begin
                    o_busy_A <= 1'b0;
                    if (i_ready_A) begin
                        o_busy_A <= 1'b1;
                        r_req <= 1'b1;
                        state_TX <= REQ_DEASSERT;
                    end
                end
                REQ_DEASSERT :
                    if (r_ack_sync) begin
                        r_req <= 1'b0;
                        state_TX <= END_TRANSACTION;
                    end
                END_TRANSACTION :
                    if( !r_ack_sync) begin
                        o_busy_A <= 1'b0;
                        state_TX <= REQ_ASSERT;
                    end
                default :
                    state_TX <= REQ_ASSERT;
            endcase
        end
    end


    ff_synchronizer #(.G_STAGES(G_STAGES)) sync_chain_A2B (
        .i_clk(i_clk_B),
        .i_rst(i_rst_B),
        .i_async(r_req),
        .o_sync(r_req_sync)
    );

    always_ff @(posedge i_clk_B) begin : handshake_B
        if(i_rst_B) begin
            state_RX <= ACK_DEASSERT;
            r_ack <= 1'b0;
            o_busy_B <= 1'b0;
            o_data_B <= '0;
        end else begin
            o_busy_B <= 1'b0;

            case (state_RX)
                ACK_ASSERT :
                    if (r_req_sync) begin
                        o_busy_B <= 1'b1;
                        state_RX <= ACK_DEASSERT;
                        r_ack <= 1'b1;
                        o_data_B <= i_data_A;
                    end
                ACK_DEASSERT : begin
                    o_busy_B <= 1'b1;
                    if( !r_req_sync) begin
                        o_busy_B <= 1'b0;
                        state_RX <= ACK_ASSERT;
                        r_ack <= 1'b0;
                    end
                end
                default :
                    state_RX <= ACK_ASSERT;
            endcase
        end
    end


endmodule : cdc_4_phase/* verilator lint_on MULTITOP */
