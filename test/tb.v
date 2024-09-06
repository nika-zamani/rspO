`default_nettype none
`timescale 1ns / 1ps

module tb ();

  // Dump the signals to a VCD file. You can view it with gtkwave.
  initial begin
    $dumpfile("tb.vcd");
    $dumpvars(0, tb);
    #1;
  end

  // Define clock and reset signals
  reg clk;
  reg rst_n;
  reg ena;
  reg [7:0] ui_in;
  reg [7:0] uio_in;
  wire [7:0] uo_out;
  wire [7:0] uio_out;
  wire [7:0] uio_oe;

  // Instantiate the module
  tt_um_nzrps user_project (
      // Include power ports for the Gate Level test:
`ifdef GL_TEST
      .VPWR(1'b1),
      .VGND(1'b0),
`endif

      .ui_in  (ui_in),    // Dedicated inputs
      .uo_out (uo_out),   // Dedicated outputs
      .uio_in (uio_in),   // IOs: Input path
      .uio_out(uio_out),  // IOs: Output path
      .uio_oe (uio_oe),   // IOs: Enable path (active high: 0=input, 1=output)
      .ena    (ena),      // enable - goes high when design is selected
      .clk    (clk),      // clock
      .rst_n  (rst_n)     // reset - active low
  );

  // Clock generation
  initial begin
    clk = 0;
    forever #5 clk = ~clk; // 100 MHz clock (10 ns period)
  end

  // Test sequence
  initial begin
    // Initialize signals
    rst_n = 0;
    ena = 1;
    ui_in = 0;
    uio_in = 0;

    // Apply reset
    #10;
    rst_n = 1;
    #10;

    // Test case 1: Player 1 chooses Rock, Player 2 chooses Rock, and press start
    uio_in = 8'b00000001;  // Player 1: Rock (00), Player 2: Rock (00), Start button pressed
    #10;
    uio_in = 8'b00000000;  // Release Start button
    #10;

    // Test case 2: Player 1 chooses Rock, Player 2 chooses Paper, and press start
    uio_in = 8'b00000101;  // Player 1: Rock (00), Player 2: Paper (01), Start button pressed
    #10;
    uio_in = 8'b00000000;  // Release Start button
    #10;

    // Test case 3: Player 1 chooses Scissors, Player 2 chooses Paper, and press start
    uio_in = 8'b00001011;  // Player 1: Scissors (10), Player 2: Paper (01), Start button pressed
    #10;
    uio_in = 8'b00000000;  // Release Start button
    #10;

    // Test case 4: Reset the system
    rst_n = 0;
    #10;
    rst_n = 1;
    #10;

    // End simulation
    $finish;
  end

endmodule

