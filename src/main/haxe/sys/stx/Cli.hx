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
}
typedef CliFailure          = stx.fail.CliFailure;
typedef CliFailureSum       = stx.fail.CliFailure.CliFailureSum;

typedef CliContextCtr       = sys.stx.cli.CliContextCtr;
typedef SysArgsCtr          = sys.stx.cli.SysArgsCtr;
typedef Executor            = sys.stx.cli.Executor;
//typedef ProgramApi        = sys.stx.cli.ProgramApi.ProgramApi;

