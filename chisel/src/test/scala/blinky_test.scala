package led

import chisel3._
import chiseltest._
import org.scalatest.flatspec.AnyFlatSpec


class BlinkyTest extends AnyFlatSpec with ChiselScalatestTester {
  behavior of "Blinky"

  it should "fill n-wide register in n-cycles (n up to 3)" in {
    test(new Blinky(3)) { c=> 
      c.clock.step(3)
      c.io.leds.expect(3.U)
    }
  }

  it should "not count if reset is set" in {
    test(new Blinky(3)) { c=> 
      c.reset.poke(true.B)
      c.clock.step(3)
      c.io.leds.expect(0.U)
    }
  }
}
