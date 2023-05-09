package sys.stx.cli.test;

import sys.stx.cli.SysCliParser;
import sys.stx.cli.CliToken;

class SysCliParserTest extends TestCase{
  public function test_(){
    final args  = ["test","-a","-b=1","--long","another"];
    final p     =  SysCliParser.apply(args);
    final t = Cluster.lift([Arg("test"),Opt("-a"),Opt("-b=1"),Opt("--long"),Arg("another")]);
    for(v in p){
      same(t,v);
    }
  }
}