package led


import circt.stage.ChiselStage
import chisel3._
import chisel3.util._

class Blinky(ctr_width: Int) extends Module {
  val io = IO(new Bundle {
    val leds = Output(UInt(3.W))
  })

  val counter_width = ctr_width
  val counter = RegInit(0.U(counter_width.W))

  counter := counter + 1.U
  io.leds := counter(counter_width-1, counter_width-3)
}

object VerilogMain extends App {
  ChiselStage.emitSystemVerilogFile(new Blinky(26))
}
