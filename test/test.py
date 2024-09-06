# SPDX-FileCopyrightText: © 2024 Tiny Tapeout
# SPDX-License-Identifier: Apache-2.0

import cocotb
from cocotb.clock import Clock
from cocotb.regression import TestFactory
from cocotb.triggers import RisingEdge, ClockCycles


@cocotb.coroutine
async def test_project(dut):
    dut._log.info("Starting the testbench")

    # Set the clock period (adjust to match your FPGA clock frequency)
    clock_period = 10  # 10 ns period for 100 MHz clock
    clock = Clock(dut.clk, clock_period, units="ns")
    cocotb.start_soon(clock.start())

    # Apply reset
    dut._log.info("Applying reset")
    dut.ena.value = 1
    dut.ui_in.value = 0
    dut.uio_in.value = 0
    dut.rst_n.value = 0
    await ClockCycles(dut.clk, 10)
    dut.rst_n.value = 1
    await RisingEdge(dut.clk)

    # Test case 1: Player 1 chooses Rock, Player 2 chooses Rock
    dut._log.info("Running Test Case 1: Both players choose Rock")
    dut.uio_in.value = 8'b00000001  # Player 1: Rock, Player 2: Rock, Start button pressed
    await RisingEdge(dut.clk)
    dut.uio_in.value = 8'b00000000  # Release Start button
    await RisingEdge(dut.clk)
    # Check the expected output (e.g., draw result)
    # Adjust the expected result as per your game logic
    assert dut.uo_out.value == expected_draw_result

    # Test case 2: Player 1 chooses Rock, Player 2 chooses Paper
    dut._log.info("Running Test Case 2: Player 1 chooses Rock, Player 2 chooses Paper")
    dut.uio_in.value = 8'b00000101  # Player 1: Rock, Player 2: Paper, Start button pressed
    await RisingEdge(dut.clk)
    dut.uio_in.value = 8'b00000000  # Release Start button
    await RisingEdge(dut.clk)
    # Check the expected output (e.g., Player 2 wins)
    assert dut.uo_out.value == expected_paper_win_result

    # Test case 3: Player 1 chooses Scissors, Player 2 chooses Paper
    dut._log.info("Running Test Case 3: Player 1 chooses Scissors, Player 2 chooses Paper")
    dut.uio_in.value = 8'b00001011  # Player 1: Scissors, Player 2: Paper, Start button pressed
    await RisingEdge(dut.clk)
    dut.uio_in.value = 8'b00000000  # Release Start button
    await RisingEdge(dut.clk)
    # Check the expected output (e.g., Player 1 wins)
    assert dut.uo_out.value == expected_scissors_win_result

    # End simulation
    dut._log.info("Ending the testbench")
    await ClockCycles(dut.clk, 10)
    cocotb.finished()

