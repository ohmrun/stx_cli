package stx.sys.cli;

class Executor extends Clazz{
  public function execute(res:Res<CliContext,CliFailure>){
    switch(res){
      case Accept(ok) : __.log().debug(ok.info());
      case Reject(e)  : __.log().debug('$e');
    }
    return @:privateAccess (stx.sys.cli.react.Main.handlers.toArray().lfold(
      (next:ProgramApi,memo:Unary<Res<CliContext,CliFailure>,Agenda<CliFailure>>) -> {  
        __.log().trace('$next');
          return memo.apply.fn().then(
            (x:Agenda<CliFailure>) -> {
              __.log().debug('${x.error}');
              return x.error.fold(
                no -> switch(no.data){
                  case Some(EXTERNAL(E_Cli_NoImplementation))   : 
                    __.log().debug(_ -> _.pure(next));
                    next.apply(res);
                  default                                 : x;
                },
                () -> x  
              );
            }
          );
        },
        x -> Agenda.lift(__.ended(End(__.fault().of(E_Cli_NoImplementation))))
    ))(res).toExecute();
  }
}