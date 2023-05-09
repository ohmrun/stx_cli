package stx.sys;

using stx.Nano;

typedef SysArgs             = stx.sys.cli.SysArgs;
typedef Arguments           = stx.sys.cli.Arguments;
typedef CliParser           = stx.sys.cli.CliParser;
typedef ExecutionMethod     = stx.sys.cli.ExecutionMethod;
typedef CliContext          = stx.sys.cli.CliContext;
typedef CliToken            = stx.sys.cli.CliToken;
typedef CliTokenSum         = stx.sys.cli.CliToken.CliTokenSum;

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

/**
 * 
 */
typedef CliConfig = {
  /**
   * Final layer will eat the rest of the input
   */
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
  
}