import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge,FallingEdge,ClockCycles
import random
from cocotb_coverage.coverage import CoverCross,CoverPoint,coverage_db


covered_number = []
g_width = int(cocotb.top.g_width)


# #Callback functions to capture the bin content showing
full = False
def notify():
	global full
	full = True

# at_least = value is superfluous, just shows how you can determine the amount of times that
# a bin must be hit to considered covered
@CoverPoint("top.data",xf = lambda x : x.i_data_A.value, bins = list(range(2**g_width)), at_least=1)
def number_cover(dut):
	covered_number.append(dut.i_data_A.value)

async def resetA(dut,cycles=1):
	dut.i_rst_A.value = 1

	dut.i_ready_A.value = 0
	dut.i_data_A.value = 0

	await ClockCycles(dut.i_clk_A,cycles)
	await FallingEdge(dut.i_clk_A)

	dut.i_rst_A.value = 0
	await RisingEdge(dut.i_clk_A)
	dut._log.info("the core was reset")

async def resetB(dut,cycles=1):
	dut.i_rst_B.value = 1

	await ClockCycles(dut.i_clk_A,cycles)
	await FallingEdge(dut.i_clk_A)

	dut.i_rst_B.value = 0
	await RisingEdge(dut.i_clk_A)
	dut._log.info("the core was reset")


@cocotb.test()
async def test(dut):
	#clocks with variable phase difference
	cocotb.start_soon(Clock(dut.i_clk_A, 3, units="ns").start())
	cocotb.start_soon(Clock(dut.i_clk_B, 11, units="ns").start())
	#reset the two clock domains
	await resetA(dut,5)
	await resetB(dut,5)	

	#cover the input space
	while(full != True):
		data = random.randint(0,2**g_width-1)
		while(data in covered_number):
			data = random.randint(0,2**g_width-1)
		dut.i_data_A.value = data 
		dut.i_ready_A.value = 1

		await RisingEdge(dut.i_clk_A)
		await FallingEdge(dut.o_busy_B)
		assert not (data != dut.o_data_B.value),"Wrong Behavior!"
		coverage_db["top.data"].add_threshold_callback(notify, 100)
		number_cover(dut)

