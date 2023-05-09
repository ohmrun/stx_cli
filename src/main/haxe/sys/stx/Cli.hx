package sys.stx;

using stx.sys.Cli;
using stx.Log;
using sys.stx.cli.Logging;

class Cli{
  static public function SysArgs(self:stx.sys.cli.Module):STX<SysArgs>{
    return STX;
  }
  static public function CliContext(self:stx.sys.cli.Module):STX<CliContext>{
    return STX;
  }
  static public function apply(self:stx.sys.cli.Module,spec:Spec):Upshot<Option<SpecValue>,CliFailure>{
    return (stx.sys.cli.SysCliParser.apply(Sys.args()).flat_map(
      x -> spec.reply().apply(x.reader()).toUpshot().errate(
        x -> E_Cli_Parse(x)
      )
    ));
  }
}
typedef CliFailure          = stx.fail.CliFailure;
typedef CliFailureSum       = stx.fail.CliFailure.CliFailureSum;

typedef CliContextCtr       = sys.stx.cli.CliContextCtr;
typedef SysArgsCtr          = sys.stx.cli.SysArgsCtr;
typedef Executor            = sys.stx.cli.Executor;
//typedef ProgramApi        = sys.stx.cli.ProgramApi.ProgramApi;

