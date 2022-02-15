package stx.sys.cli;

//TODO Pass InputRequests forward to console
class Executor{
  public var context(default,null) : CliContext;

  public function new(?context){
    this.context = context == null ? CliContext.unit() : context;
  }
  public function execute(){
    return @:privateAccess (stx.sys.Cli.handlers.toArray().lfold(
      (next:Program,memo:Produce<stx.io.Process,CliFailure>) -> memo.fold_flat_map(
        (res:Res<Process,CliFailure>) -> __.tracer()(res).fold(
          ok -> Produce.pure(ok),
          no -> switch(no.val){
            case Some(REJECT(E_NoImplementation))   : 
              __.log().debug(_ -> _.pure(next));
              (Modulate.fromApi(next).produce(__.accept(context)));
            default                                 : (Produce.reject(no));
          }
        )
      ),
      Produce.reject(__.fault().of(E_NoImplementation))
    ));
  } 
}