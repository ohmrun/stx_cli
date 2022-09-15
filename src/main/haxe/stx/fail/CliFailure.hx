package stx.fail;

using stx.Nano;
import stx.Io;
import stx.sys.Cli;

enum CliFailure{
  E_Cli(reason:String);
  E_Cli_NoInput;
  E_Cli_UnknownOption(v:CliToken);
  E_Cli_ExpectingArg(v:CliToken);
  E_Cli_NoSectionNamed(name:String);
  E_Cli_NoImplementation;
  E_Cli_Options(opts:Cluster<stx.sys.cli.core.OptionSpec.OptionSpecApi>);
  E_Cli_NoHandler;
  E_Cli_ErrorCode(int:Int);
  E_Cli_CannotFindClass(string:String);
  E_Cli_CommandShouldBeAccessor(cmd:CliToken);
  E_Cli_Io(f:IoFailure);
  E_Cli_ProcessFailure(e:ProcessFailure);
  E_Cli_Spec(spec:stx.sys.cli.core.Spec);
  E_Cli_ArgumentSpec(spec:stx.sys.cli.core.spec.term.ArgumentSpec);
  E_Cli_Reason(f:CliFailure,reason:String);
  E_Cli_OptionExcludedBy(opt:stx.sys.cli.core.OptionSpec.OptionSpecApi,v:stx.sys.cli.core.OptionValue.OptionValueApi,tk:CliToken);
  E_Cli_NoValueFor(p:stx.sys.cli.core.OptionSpec.OptionSpecApi);
}