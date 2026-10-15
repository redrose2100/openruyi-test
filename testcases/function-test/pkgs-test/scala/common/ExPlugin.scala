package localhost

import scala.tools.nsc
import nsc.Global
import nsc.Phase
import nsc.plugins.Plugin
import nsc.plugins.PluginComponent

class Silly(val global: Global) extends Plugin {
  import global._

  val name = "silly"
  val description = "goose"
  val components = List[PluginComponent](Component)

  var level = 1000000

  override def processOptions(options: List[String], error: String => Unit): Unit = {
    for (option
           <- options) {
      if (option.startsWith("level:")) {
        level = option.substring("level:".length).toInt
      } else {
        error("Option not understood: "+option)
      }
    }
  }

  override val optionsHelp: Option[String] = Some(
    "  -P:silly:level:n             set the silliness to level n")

  private object Component extends PluginComponent {
    val global: Silly.this.global.type = Silly.this.global
    val runsAfter = List[String]("refchecks");
    val phaseName = Silly.this.name
    def newPhase(_prev: Phase) = new SillyPhase(_prev)

    class SillyPhase(prev: Phase) extends StdPhase(prev) {
      override def name = Silly.this.name
      def apply(unit: CompilationUnit): Unit = {
        println("Silliness level: " + level)
      }
    }
  }
}