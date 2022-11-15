package stx.sys.cli;

class Executor extends Clazz{
  public function execute(res:Res<CliContext,CliFailure>){
    return @:privateAccess (stx.sys.cli.Run.handlers.toArray().lfold(
      (next:Program,memo:Program) -> {  
          return memo.fn().then(
            (x:Agenda<CliFailure>) -> x.error.fold(
              no -> switch(no.data){
                case Some(EXTERIOR(E_Cli_NoImplementation))   : 
                  __.log().debug(_ -> _.pure(next));
                  next(res);
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