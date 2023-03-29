package stx.sys.cli;

using stx.Log;
using stx.Nano;
using stx.Test;
import stx.sys.cli.Test;
import stx.sys.cli.test.*;

class Test{
static public function tests(){
    return [
      //new CliTest(),
      //new ParserTest(),
      new SysCliParserTest(),
      new ReadmeTest()
    ];
  }
  static public function main(){
    var lX  = __.log().logic();
    __.logger().global().configure(
      logger -> logger.with_logic(
        lg -> lg.or(
          lX.Tags([
            "**/*"
          ]).and(
            lX.level(DEBUG)
          )
        )
      )
    );
    __.test().auto();
  }
}
