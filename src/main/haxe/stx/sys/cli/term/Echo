package stx.sys.cli.term;

class Echo extends eu.ohmrun.modulate.term.Sync<CliContext,Process,CliFailure> implements ModulateApi<CliContext,Process,CliFailure>{
  public function new(){}
  public function apply(x:Res<CliContext,CliFailure>){
    __.log().debug('echo: $x');
    return __.success(
      x.map(
        ctx -> {
          //trace(ctx.info());
          return Process.make0(['echo',ctx.info()]);
        }
      )
    );
  }
}