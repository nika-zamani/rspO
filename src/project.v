// /*
//  * Copyright (c) 2024 Your Name
//  * SPDX-License-Identifier: Apache-2.0
//  */

// `default_nettype none

// module tt_um_example (
//     input  wire [7:0] ui_in,    // Dedicated inputs
//     output wire [7:0] uo_out,   // Dedicated outputs
//     input  wire [7:0] uio_in,   // IOs: Input path
//     output wire [7:0] uio_out,  // IOs: Output path
//     output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
//     input  wire       ena,      // always 1 when the design is powered, so you can ignore it
//     input  wire       clk,      // clock
//     input  wire       rst_n     // reset_n - low to reset
// );

//   // All output pins must be assigned. If not used, assign to 0.
//   assign uo_out  = ui_in + uio_in;  // Example: ou_out is the sum of ui_in and uio_in
//   assign uio_out = 0;
//   assign uio_oe  = 0;

//   // List all unused inputs to prevent warnings
//   wire _unused = &{ena, clk, rst_n, 1'b0};

//     input logic clk,                  // Clock signal
//     input logic rst_n,                // Active-low reset
//     input logic [1:0] player1_sw,     // Player 1 switches (2 bits)
//     input logic [1:0] player2_sw,     // Player 2 switches (2 bits)
//     input logic start_btn,            // Start button
//     output logic [6:0] seg,           // 7-segment display segments
//     output logic [3:0] an             // 7-segment display anodes
// );

//     // Internal signals
//     logic [1:0] player1_choice;
//     logic [1:0] player2_choice;
//     logic [1:0] game_result;
//     logic done;

//     // Game logic instance
//     rock_paper_scissors_game u_game (
//         .clk(clk),
//         .rst_n(rst_n),
//         .player1_choice(player1_choice),
//         .player2_choice(player2_choice),
//         .start(start_btn),
//         .game_result(game_result),
//         .done(done)
//     );

//     // Map switches to player choices
//     assign player1_choice = player1_sw;
//     assign player2_choice = player2_sw;

//     // Seven-segment display driver
//     seven_segment_display u_seg (
//         .clk(clk),
//         .rst_n(rst_n),
//         .data(game_result),
//         .seg(seg),
//         .an(an)
//     );

// endmodule


// endmodule

`default_nettype none

module tt_um_nzrps (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

    // Define internal signals
    logic [1:0] player1_choice;
    logic [1:0] player2_choice;
    logic [1:0] game_result;
    logic start;
    logic done;

    // Assign switches to player choices
    assign player1_choice = uio_in[1:0];    // e.g., Switches 0 and 1
    assign player2_choice = uio_in[3:2];    // e.g., Switches 2 and 3
    assign start = uio_in[4];               // e.g., Start button

    // Game logic instance
    rock_paper_scissors_game u_game (
        .clk(clk),
        .rst_n(rst_n),
        .player1_choice(player1_choice),
        .player2_choice(player2_choice),
        .start(start),
        .game_result(game_result),
        .done(done)
    );

    // Seven-segment display driver instance
    seven_segment_display u_seg (
        .clk(clk),
        .rst_n(rst_n),
        .data(game_result),
        .seg(uo_out[6:0]), // Assign to uo_out[6:0] (7-segment display segments)
        .an(uo_out[7])    // Assign to uo_out[7] (7-segment display anode, assuming 1-digit display)
    );

    // IOs: Output enable for IOs, set to output
    assign uio_oe = 8'b1111_1111;

    // All unused inputs or outputs must be handled. For now, set them to 0.
    assign uo_out[7:0] = 0;
    assign uio_out = 0;

    // Prevent warnings about unused inputs
    wire _unused = &{ena, clk, rst_n, 1'b0};

endmodule

