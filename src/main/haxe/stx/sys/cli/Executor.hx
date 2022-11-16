package stx.sys.cli;

class Executor extends Clazz{
  public function execute(res:Res<CliContext,CliFailure>){
    return @:privateAccess (stx.sys.cli.Run.handlers.toArray().lfold(
      (next:Program,memo:Unary<Res<CliContext,CliFailure>,Agenda<CliFailure>>) -> {  
          return memo.apply.fn().then(
            (x:Agenda<CliFailure>) -> x.error.fold(
              no -> switch(no.data){
                case Some(EXTERNAL(E_Cli_NoImplementation))   : 
                  __.log().debug(_ -> _.pure(next));
                  next.apply(res);
                default                                 : x;
              },
              () -> x  
            )
          );
        },
        x -> Agenda.lift(__.ended(End(__.fault().of(E_Cli_NoImplementation))))
    ))(res).toExecute();
  }
}