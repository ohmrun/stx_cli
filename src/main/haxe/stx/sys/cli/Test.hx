package stx.sys.cli;

using stx.Test;
import stx.sys.cli.Test;
import stx.sys.cli.test.*;

class Test{
  static public function tests(){
    return [
      new CliTest(),
      new ParserTest()
    ];
  }
  static public function main(){
    var log = __.log().global;
        log.includes.push("stx/parse");
        log.includes.push("stx/sys/cli");
        //log.includes.push("**/*");
        log.level = TRACE;
    __.test().auto();
  }
}
