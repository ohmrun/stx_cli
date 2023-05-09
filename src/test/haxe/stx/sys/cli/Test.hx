package sys.stx.cli;

using stx.Log;
using stx.Nano;
using stx.Test;
import sys.stx.cli.Test;
import sys.stx.cli.test.*;

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
          lX.tags([
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
