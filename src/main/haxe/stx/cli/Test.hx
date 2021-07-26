package stx.cli;

import stx.cli.test.*;

class Test{
  static public function main(){
    __.test([
      new CliParserTest()
    ]);
  }
}
class CliParserTest extends haxe.unit.TestCase{
  public function _testParser(){
    var reader = 'abs "TEST" 1'.reader();
    var parser = new stx.cli.pack.Parser();
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
        .crack()
        .fudge();
    trace(cwd);
    var fn  = cwd.entry('run.n').canonical(env.device.sep);
    trace(fn);    
    var cmd = Sys.command('neko',[fn,'cmd.test.TestCliParse','1','true','"who kernoos"']);
    trace(cmd);
  }
}