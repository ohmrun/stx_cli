package stx.sys.cli.term;

class Command implements ProgramApi extends eu.ohmrun.fletcher.term.Sync<Res<CliContext,CliFailure>,Res<stx.io.Process,CliFailure>,Noise>{
  
  public var command(default,null)    : String;

  public function new(command,?arguments){
    this.command    = command; 
  }
  public function apply(i:Res<CliContext,CliFailure>):ArwOut<Res<Process,CliFailure>,Noise>{
    return __.success(
      i.map(
        ok -> stx.io.Process.make0(
          [command].imm().concat(ok.args.args_without_specials().map(Std.string))
        )
      )
    ); 
  }
}