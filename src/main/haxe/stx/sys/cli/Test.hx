package stx.sys.cli;

using stx.Test;

import stx.sys.cli.test.*;

class Test{
  static public function main(){
    var log = __.log().global;
        log.includes.push("eu/ohmrun/fletcher");
        log.includes.push("stx/asys");
    __.test([
      new CliParserTest()],
      []
    );
  }
}
class CliParserTest extends TestCase{
  public function _testParser(){
    var reader = 'abs "TEST" 1'.reader();
    var parser = new stx.sys.cli.Parser();
    var result = parser.parse(reader).fudge();
    trace(result);
  }
  public function test(){
    trace('test');
    var env = __.asys().local();
    var cwd = 
      env
        .device.shell
        .cwd.pop()
        .provide(env)
        .fudge();
    trace(cwd);
    // var fn  = cwd.entry('run.n').canonical(env.device.sep);
    // trace(fn);    
    // var cmd = std.Sys.command('neko',[fn,'cmd.test.TestCliParse','1','true','"who kernoos"']);
    // trace(cmd);
  }
}