package stx.sys.cli;

using stx.Test;

import stx.sys.cli.test.*;

class Test{
  static public function main(){
    var log = __.log().global;
        //log.includes.push("eu/ohmrun/fletcher");
    __.test([
        //new CliParserTest(),
        new CliTest()
      ],
      []
    );
  }
}
