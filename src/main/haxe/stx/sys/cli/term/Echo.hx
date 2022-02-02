package stx.sys.cli.term;

class Echo extends eu.ohmrun.modulate.term.Sync<Context,Process,CliFailure> implements ModulateApi<Context,Process,CliFailure>{
  public function new(){}
  public function apply(x:Res<Context,CliFailure>){
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