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
    var log = __.log().global;
      // .with_logic(
      //   l -> l.pack("stx/parse").or("")
      // )
        //log.includes.push("stx/parse");
        //log.includes.push("stx/sys/cli");
        //log.includes.push("**/*");
        //log.level = TRACE;
    __.test().auto();
  }
}
