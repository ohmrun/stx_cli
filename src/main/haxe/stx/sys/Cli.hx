package stx.sys;

using stx.Log;
using stx.sys.cli.Logging;

typedef CliFailure          = stx.fail.CliFailure;
typedef CliFailureSum       = stx.fail.CliFailure.CliFailureSum;

typedef SysArgs             = stx.sys.cli.SysArgs;
typedef Arguments           = stx.sys.cli.Arguments;
typedef CliParser           = stx.sys.cli.CliParser;
typedef ExecutionMethod     = stx.sys.cli.ExecutionMethod;
typedef CliContext          = stx.sys.cli.CliContext;
typedef CliToken            = stx.sys.cli.CliToken;
typedef CliTokenSum         = stx.sys.cli.CliToken.CliTokenSum;

typedef Executor            = stx.sys.cli.Executor;
//typedef ProgramApi        = stx.sys.cli.ProgramApi.ProgramApi;
typedef ProgramApi          = stx.sys.cli.ProgramApi;
typedef ProgramCls          = stx.sys.cli.ProgramCls;

typedef OptionSpecApi       = stx.sys.cli.application.spec.OptionSpec.OptionSpecApi;
typedef OptionSpecCls       = stx.sys.cli.application.spec.OptionSpec.OptionSpecCls;
typedef OptionSpecCtr       = stx.sys.cli.application.spec.OptionSpec.OptionSpecCtr;

typedef OptionValueCls      = stx.sys.cli.application.spec.OptionValue.OptionValueCls;
typedef OptionValueApi      = stx.sys.cli.application.spec.OptionValue.OptionValueApi;

typedef Spec                = stx.sys.cli.application.Spec;
typedef SpecValue           = stx.sys.cli.application.spec.SpecValue;

typedef OptionKind          = stx.sys.cli.application.spec.OptionKind;
typedef CliConfig = {
  final greedy : Bool;
}
class CliConfigCtr{
  static public function unit():CliConfig{
    return {
      greedy : true
    }
  }
}

class Cli{
  static public function cli(wildcard:Wildcard){
    return new stx.sys.cli.Module();
  }  
  static public function main(){
    stx.sys.cli.react.Main.main();
  }
}