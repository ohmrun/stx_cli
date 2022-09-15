package stx.sys.cli;

using stx.Test;

import stx.sys.cli.test.*;

class Test{
  static public function main(){
    var log = __.log().global;
        log.includes.push("stx/parse");
        log.includes.push("stx/sys/cli");
        log.level = TRACE;
    __.test().run([
        //new CliParserTest(),
        new CliTest()
      ],
      []
    );
  }
}
