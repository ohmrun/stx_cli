package sys.stx.cli.test;

class CliParserTest extends TestCase{
  public function _testParser(){
    var reader = 'abs "TEST" 1'.reader();
    var parser = new CliParser();
    var result = parser.parse(reader).fudge();
    trace(result);
  }
  public function test(async:Async){
    trace('test');
    var env     = __.asys().local();
    var handler = x -> {
      trace(x);
      async.done();
    }
    __.ctx(env,handler).load(
      env.device.shell.cwd.pop()
    ).submit();
    // var fn  = cwd.entry('run.n').canonical(env.device.sep);
    // trace(fn);    
    // var cmd = std.Sys.command('neko',[fn,'cmd.test.TestCliParse','1','true','"who kernoos"']);
    // trace(cmd);
  }
}