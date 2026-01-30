// scala-cli run bitStuff.scala

//> using scala "2.13.16"
//> using dep "org.chipsalliance::chisel:7.8.0"
//> using plugin "org.chipsalliance:::chisel-plugin:7.8.0"
//> using options "-unchecked" "-deprecation" "-language:reflectiveCalls" "-feature" "-Xcheckinit" "-Xfatal-warnings" "-Ywarn-dead-code" "-Ywarn-unused" "-Ymacro-annotations"

import chisel3._
// _root_ disambiguates from package chisel3.util.circt if user imports chisel3.util._
import _root_.circt.stage.ChiselStage

class BitStuff extends Module {
  val a = IO(Input(UInt(8.W)))
  val b = IO(Input(UInt(4.W)))
  val c = IO(Input(UInt(2.W)))
  val out = IO(Output(UInt(10.W)))

  val ab = a & b
  val abc = ab + c
  val sum = abc + a
  val finalOut = sum | b
  out := finalOut
}

object Main extends App {
  // Use a patched firtool which emits RTLIL when asked for HW
  val rtlil = ChiselStage.emitHWDialect(gen = new BitStuff,
      args = Array("--firtool-binary-path", "../circt/build/bin/firtool"),
      firtoolOpts = Array("--default-layer-specialization=disable"),
    )
  import java.io._
  val pw = new PrintWriter(new File("bitStuff.mlir"))
  pw.write(rtlil)
  pw.close()
}

