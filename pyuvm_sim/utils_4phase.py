from cocotb.triggers import Timer,RisingEdge,FallingEdge,ClockCycles
from cocotb.queue import QueueEmpty, Queue
import cocotb
import enum
import random
from cocotb_coverage import crv 
from cocotb_coverage.coverage import CoverCross,CoverPoint,coverage_db
from pyuvm import utility_classes



class HandShake4PhaseBfm(metaclass=utility_classes.Singleton):
    def __init__(self):
        self.dut = cocotb.top
        self.driver_queue = Queue(maxsize=1)
        self.data_mon_queue = Queue(maxsize=0)
        self.result_mon_queue = Queue(maxsize=0)

    async def send_data(self, data):
        await self.driver_queue.put(data)

    async def get_data(self):
        data = await self.data_mon_queue.get()
        return data

    async def get_result(self):
        result = await self.result_mon_queue.get()
        return result

    async def resetA(self):
        await RisingEdge(self.dut.i_clk_A)
        self.dut.i_rst_A.value = 1
        self.dut.i_ready_A.value = 0
        self.dut.i_data_A.value = 0 
        await ClockCycles(self.dut.i_clk_A,5)
        self.dut.i_rst_A.value = 0
        await RisingEdge(self.dut.i_clk_A)

    async def resetB(self):
        await RisingEdge(self.dut.i_clk_B)
        self.dut.i_rst_B.value = 1
        await ClockCycles(self.dut.i_clk_B,5)
        self.dut.i_rst_B.value = 0
        await RisingEdge(self.dut.i_clk_B)

    async def driver_bfm(self):
        while True:
            await RisingEdge(self.dut.i_clk_A)
            try:
                (ready,data) = self.driver_queue.get_nowait()
                self.dut.i_ready_A.value = ready
                self.dut.i_data_A.value = data
            except QueueEmpty:
                pass

    async def data_mon_bfm(self):
        while True:
            await RisingEdge(self.dut.o_busy_A)
            data = self.dut.i_data_A.value
            self.data_mon_queue.put_nowait(data)

    async def result_mon_bfm(self):
        while True:
            await FallingEdge(self.dut.r_req_syncB)
            self.result_mon_queue.put_nowait(self.dut.o_data_B.value)


    def start_bfm(self):
        cocotb.start_soon(self.driver_bfm())
        cocotb.start_soon(self.data_mon_bfm())
        cocotb.start_soon(self.result_mon_bfm())